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
        let vc3 = UINavigationController(rootViewController: AllCharactersViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "list.dash")
        vc2.tabBarItem.image = UIImage(systemName: "list.dash")
        vc3.tabBarItem.image = UIImage(systemName: "list.dash")


        vc1.title = "All Publishers"
        vc2.title = "All Comics"
        vc3.title = "All Characters"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2], animated: true)
    }
}
