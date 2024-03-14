//
//  PublisherCharactersViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/8/23.
//

import UIKit
import CoreData

class SelectedPublisherCharactersViewController: UIViewController, LoadAnimationDelegate {
    
    public var selectedPublisherName = ""
    public var selectedPublisherDetailsURL = ""
    private var characters = [Character]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        //adding "navigationItem" before "title" changes title of VC w/out touching the icon
        if selectedPublisherName.contains("Comics") {
            selectedPublisherName = selectedPublisherName.replacingOccurrences(of: "Comics", with: "Comix")
        }
        title = "\(selectedPublisherName)"
        navigationItem.title = "\(selectedPublisherName) Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
   
        
        Task {
            presentLoadingAnimationViewController()
            
            await configureCharacters(withPublisherDetailsURL: selectedPublisherDetailsURL)
            print("configureCharacters was successful. about to add subview")
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
            
//            dismissLoadingAnimationViewController()
        }
                
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configureCharacters(withPublisherDetailsURL publisherDetailsURL: String) async {

        if let results = try? await APICaller.shared.getPublisherCharactersAPI(withPublisherDetailsURL: publisherDetailsURL) {
            
            self.characters += results
           
        } else {
            print("something went wrong in configureCharacters().")
        }
        
    }
    
    func presentLoadingAnimationViewController() {
        let loadingAnimationVC = LoadAnimationViewController()
        
        loadingAnimationVC.delegate = self
        //hide the navigation controller & tabs
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.pushViewController(loadingAnimationVC, animated: false)
    }
    
    func dismissLoadingAnimationViewController() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false

        self.navigationController?.popViewController(animated: false)
    }
    
}

//MARK: DELEGATE & DATASOURCE METHODS
extension SelectedPublisherCharactersViewController: UITableViewDelegate, UITableViewDataSource {
    //datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
//"as! CharacterSelectViewCell" gives access to iboutles in CharacterSelectViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterSelectViewCell", for: indexPath) as! CharacterSelectViewCell
        
        let theCharacter = characters[indexPath.row]
        cell.textLabel?.text = theCharacter.characterName
        
        //configuring / linking CharacterSelectViewCell's IBOutlets to Character model props
        //more to come (including images & detailed bios)
//        cell.characterViewCellName?.text = theCharacter.characterName
       
        return cell
    }
    
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCharacterVC
        //make selectedcharacter VCb
        let selectedCharacterDetailsURL = characters[indexPath.row].characterDetailsURL
        print(selectedCharacterDetailsURL)

    }
}







//OG INIT METHODS
//    init(selectedPublisher: String) {
//        self.selectedPublisher = selectedPublisher
//        super.init(nibName: nil, bundle: nil)
//
//    }

//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//OG FILTER METHOD - BEFORE SEARCHING PUBLISHER/{PUBLISHER}
//not working when right side of '==' isn't hard coded
//i see, returning nil b/c first call doesn't incl. all publishers, so no 'selectedPublisher' in some cases
//so, nothing wrong w code, sumn' wrong w calling for spec. publisher calls in comic vine API
//but what if i dont need to filter, what if the characters come in filtered?
//            let filtertedResults = results.filter {$0.publisherName == "Malibu"}
//            print("inside configureCharacters & was able to filter the results via Character instance's publisherName prop. FIRST RESULT = \(String(describing: filtertedResults.first))")
