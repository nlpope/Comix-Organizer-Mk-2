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
        
        var selectedPublisher: Publisher
        
        let vc1 = UINavigationController(rootViewController: AllPublishersViewController())
        let vc2 = UINavigationController(rootViewController: ComicBoxViewController())
        let vc3 = UINavigationController(rootViewController: TitleCharacterSearchViewController())
       
        
    
        vc1.tabBarItem.image = UIImage(systemName: "list.dash")
        vc2.tabBarItem.image = UIImage(systemName: "books.vertical.fill")
     

        vc1.title = "Publishers"
        vc2.title = "Comic Box"
        
        tabBar.tintColor = .label

        setViewControllers([vc1, vc2], animated: true)
    }
}


