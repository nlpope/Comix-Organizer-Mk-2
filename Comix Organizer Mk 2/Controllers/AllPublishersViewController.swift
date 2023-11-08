//
//  AllPublishersViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import UIKit

//this is the HomeViewController / HomeVC
//instead of giving access to all metron has to offer
//try adding a search bar to pull specific publishers
//then list all of user's picks
//dont forget to add logic for when publisher cant be found/pulled

class AllPublishersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "All Publishers"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
}

//MARK: DELEGATE & DATASOURCE METHODS
extension AllPublishersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

