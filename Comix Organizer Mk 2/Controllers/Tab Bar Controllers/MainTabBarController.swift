//
//  MainTabBarViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/8/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var selectedPublisher = ""
        
        let vc1 = UINavigationController(rootViewController: AllPublishersViewController())
        let vc2 = UINavigationController(rootViewController: ComicBoxViewController())
        let vc3 = UINavigationController(rootViewController: TitleCharacterSearchViewController())
        let vc4 = UINavigationController(rootViewController: UserProfileViewController())
       
        
    
        vc1.tabBarItem.image = UIImage(systemName: "list.dash")
        vc2.tabBarItem.image = UIImage(systemName: "books.vertical.fill")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle.fill")
        vc4.tabBarItem.image = UIImage(systemName: "person.circle.fill")
     

        vc1.title = "Publishers"
        vc2.title = "Comic Box"
        vc3.title = "Search"
        vc4.title = "User Profile"
        
        tabBar.tintColor = .label

        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}


