//
//  AllTeamsViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 12/20/23.
//

import UIKit
import CoreData

class AllTeamsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Teams"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
}
