//
//  MainTabBarViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/8/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: AllPublishersViewController())
        let vc2 = UINavigationController(rootViewController: AllComicsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "list.dash")
        vc2.tabBarItem.image = UIImage(systemName: "list.dash")

        vc1.title = "All Publishers"
        vc2.title = "All Comics"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2], animated: true)
    }
}
