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
        view.backgroundColor = .systemBackground
        title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
//        Task {
//            await configureCharacters(with: )
//            tableView.delegate = self
//            tableView.dataSource = self
//            tableView.frame = view.bounds
//        }
    }
    
    private func configureCharacters(with publisher: String) async {
        if let results = try? await APICaller.shared.getCharacters() {
            self.characters += results.filter {$0.publisher == publisher}
        } else {
            print("something went wrong in configureCharacters()")
        }
        
    }

}
