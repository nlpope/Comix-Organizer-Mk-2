//
//  PublisherCharactersViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/8/23.
//

import UIKit
import CoreData

//03.15: commented out - LoadAnimationDelegate protocol below
class SelectedPublisherCharactersViewController: UIViewController {
    
    public var selectedPublisherName = ""
    public var selectedPublisherDetailsURL = ""
    private var selectedPublisherCharacters = [Character]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "\(selectedPublisherName)"
        //adding "navigationItem" before "title" changes title of VC w/out touching the icon
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
            
            dismissLoadingAnimationViewController()
        }
                
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configureCharacters(withPublisherDetailsURL publisherDetailsURL: String) async {

        if let results = try? await APICaller.shared.getPublisherCharactersAPI(withPublisherDetailsURL: publisherDetailsURL) {
            
            self.selectedPublisherCharacters += results
           
        } else {
            print("something went wrong in configureCharacters().")
        }
        
    }
    
    func presentLoadingAnimationViewController() {
        let loadingAnimationVC = LoadAnimationViewController()
        //03.15: commented out - loadingAnimationVC.delegate = self
        
        //hide the navigation controller & tabs
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.pushViewController(loadingAnimationVC, animated: true)
    }
    
    func dismissLoadingAnimationViewController() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false

        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: DELEGATE & DATASOURCE METHODS
extension SelectedPublisherCharactersViewController: UITableViewDelegate, UITableViewDataSource {
    //datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPublisherCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let theCharacter = selectedPublisherCharacters[indexPath.row]
        cell.textLabel?.text = theCharacter.characterName
       
        return cell
    }
    
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCharacterVC
        //make selectedcharacter VCb
        let selectedCharacterDetailsURL = selectedPublisherCharacters[indexPath.row].characterDetailsURL
        print(selectedCharacterDetailsURL)
        print("it works")

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
