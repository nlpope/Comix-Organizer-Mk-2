//
//  AllPublishersViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import UIKit
import CoreData

//this is the HomeViewController / HomeVC
//instead of giving access to all metron has to offer
//try adding a search bar to pull specific publishers
//then list all of user's picks
//dont forget to add logic for when publisher cant be found/pulled

class AllPublishersViewController: UIViewController {
    
    private var publishers = [Publisher]()

    let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    //CORE DATA STEP 2
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        title = "Publishers"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        configurePublishers()
    }
    
    private func configurePublishers() {
        print("calling configurePublishers()")
        APICaller.shared.getPublishers { [weak self] result in
            switch result {
            case .success(let returnedPublishers):
                self?.publishers.append(contentsOf: returnedPublishers)
            case .failure(let error):
                print("configurePublishers() threw an error:", error.localizedDescription)
            }
        }
    }
    
    //should this go in DataPersistenceManager?
//    func getAllPublishers() {
//        do {
//            publishers = try context.fetch(Publisher.fetchRequest())
//            
//            DispatchQueue.main.async {
//                //anything ui related do on main thread
//                self.tableView.reloadData()
//                print("reloadData called from getAllPublishers() just now")
//            }
//            
//        } catch {
//            print("there was an error \(error)")
//        }
//        
//    }
}

//MARK: DELEGATE & DATASOURCE METHODS
extension AllPublishersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "dummy thicc"
        return cell
    }
    
    
}

/**
 > hide/reveal debug area = cmd + shift + Y
 > hide/reveal console = cmd + shift + C
 > hide/reveal left pane = cmd + 0
 > hide/reveal right pane = cmd + shift + 0
 > hide/reveal preview window = cmd + shift + enter
 
 > edit this boilerplate using: cmd + shift + L
 > storyboard object lisit: cmd + shift + L
 
 --------------------------
 NOTES:
 
 11.20.23
 > creating postman account to pull metron data over
 > https://www.youtube.com/watch?v=VywxIQ2ZXw4
 >> @ 5.37
 
 11.21.23
 > Learning postman to sync w Metron & pull publishers
 
 11.22.23
 > downloading postman app & reviewing postman/metron docs
 >> do I need Mokkari?
 
 11.24.23
 > S.O. auth process link
 >>  https://stackoverflow.com/questions/24379601/how-to-make-an-http-request-basic-auth-in-swift 
 --------------------------
 */
