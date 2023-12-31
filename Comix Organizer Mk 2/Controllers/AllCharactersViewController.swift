//
//  AllCharactersViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/8/23.
//

import UIKit
import CoreData

class AllCharactersViewController: UIViewController {
    
    
    
    private var characters: [Character] = [Character]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
    
    func configureCharacters(with publisher: String) async {
        print("inside configureCharacters & publisher = \(publisher)")
        //12.30 LEADS TO PROBLEM CHILD
        if let results = try? await APICaller.shared.getCharacters() {
            //raw results coming through, but I lose it below
            //works up to this point, if publisher is replaced w "DC Comics" || hard coded string value
            print("just about to filter & publisher = \(publisher)")
            let filteredResults = results.filter {$0.publisherName == "\(publisher)"}
//            {$0.publisherName == "DC Comics"}
            
            //this is where I get an empty array
            print("filtered results: \(filteredResults)")
            self.characters += filteredResults
            print("characters stuffed in filtered results = \(characters)")
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
        
        cell.characterViewCellThumbnail?.load(withURL: theCharacter.characterThumbnailURL)
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
