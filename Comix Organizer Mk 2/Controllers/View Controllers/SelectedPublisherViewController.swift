//
//  PublisherTitlesViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/6/24.
//

import UIKit
import CoreData

//Titles = Volumes in API
class selectedPublisherViewController: UIViewController {
    public var selectedPublisherName = ""
    public var selectedPublisherDetailsURL = ""
    
    private var titles = [Volume]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
//        Task {
//        }
        print("viewWillAppear was triggered")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "\(selectedPublisherName) Comix"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configurePublisherTitles(withPublisherDetailsURL publisherDetailsURL: String) async {
        
    }
}
