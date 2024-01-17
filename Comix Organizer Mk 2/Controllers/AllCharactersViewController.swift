//
//  AllCharactersViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/8/23.
//

import UIKit
import CoreData

class AllCharactersViewController: UIViewController {
    //work on context & data persistence manager next
    
    public var characterDetailURL = ""
    private var characters = [Character]()
    let shared = AllPublishersViewController()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        view.backgroundColor = .systemBackground
        title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        Task {
//            print("inside AllCharactersVC'S viewDidAppear")
//            await self.configureCharacters(withPublisher: selectedPublisher)
//        }
//    }
    
    
    
    func configureCharacters(withPublisherDetailsURL publisherDetailsURL: String) async {

        if let results = try? await APICaller.shared.getCharactersAPI(withPublisherDetailsURL: publisherDetailsURL) {
            self.characters += results
           
        } else {
            print("something went wrong in configureCharacters().")
        }
        
    }
    
}

//MARK: DELEGATE & DATASOURCE METHODS
extension AllCharactersViewController: UITableViewDelegate, UITableViewDataSource {
    //datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //"as! CharacterSelectViewCell" gives access to iboutlets in CharacterSelectViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterSelectViewCell", for: indexPath) as! CharacterSelectViewCell
        
        let theCharacter = characters[indexPath.row]
        
        //configuring / linking CharacterSelectViewCell's IBOutlets to Character model props
        //more to come (including images & detailed bios)
        cell.characterViewCellName?.text = theCharacter.characterName
       
        return cell
    }
    
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(characters[indexPath.row].characterName)")
        //        tableView.deselectRow(at: indexPath, animated: true)
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
