//
//  AllCharactersViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/8/23.
//

import UIKit
import CoreData

class AllCharactersViewController: UIViewController {
    //move to data persistence manager? - create data persistence manager?
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //    var selectedPublisher = ""
    private var characters = [Character]()
    let shared = AllPublishersViewController()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    //    init(selectedPublisher: String) {
    //        self.selectedPublisher = selectedPublisher
    //        super.init(nibName: nil, bundle: nil)
    //
    //    }
    
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configureCharacters(withPublisher publisher: String) async {
        print("inside configureCharacters & publisher = \(publisher)")

        if let results = try? await APICaller.shared.getCharactersAPI() {
            
            
            print("just about to filter & publisher = \(publisher)")
          
            let filteredResults = results.filter {$0.publisherName == "DC Comics"}
            //            {$0.publisherName == "DC Comics"}
            
            self.characters += filteredResults
        } else {
            print("something went wrong in configureCharacters()")
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
        
        cell.characterViewCellName?.text = theCharacter.characterName
        cell.characterViewCellAbbreviatedBio?.text = theCharacter.characterAbbreviatedBio
        cell.characterViewCellDetailedBio?.text = theCharacter.characterDetailedBio
        
        cell.characterViewCellThumbnail?.load(withURL: theCharacter.characterThumbnailURL!)
        //above = configuring / linking CharacterSelectViewCell's IBOutlets to Character model props
        //how to convert url (in Character model) to type uiimageView (in characterselectviewcell)?
        
        
        
        return cell
    }
    
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //12.31 PROBLEM CHILD?
        //        print("\(characters[indexPath.row].publisherName)")
        //        tableView.deselectRow(at: indexPath, animated: true)
    }
}
