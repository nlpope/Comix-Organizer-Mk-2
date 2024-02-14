//
//  UserProfileViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/13/24.
//

import Foundation
import UIKit

class UserProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "User Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
}
