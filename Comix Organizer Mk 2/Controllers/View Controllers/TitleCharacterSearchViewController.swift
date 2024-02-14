//
//  TitleCharacterSearchViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/12/24.
//

import Foundation
import UIKit

class TitleCharacterSearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        let searchToggler = UISwitch(
            frame: CGRect(
                x: self.view.center.x,
                y: self.view.center.y,
                width: 100,
                height: 100)
        )
       
        searchToggler.addTarget(self, action: #selector(self.switchStateDidChange(_ :)), for: .valueChanged)
        searchToggler.setOn(true, animated: false)
        
        
        self.view.addSubview(searchToggler)
    }
    
    @objc func switchStateDidChange(_ sender: UISwitch!) {
        if sender.isOn {
            print("UISwitch state is now ON")
        } else {
            print("UISwitch state is now OFF")
        }
    }
    
}

//add selector up top - if it reads "titles", the search will return volumes from selectedPublisher; if "Characters", the search will return characters from selectedPublisher
