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
          
        #warning("change root vc to searchVC")
        let vc1 = UINavigationController(rootViewController: COSearchVC())
        let vc2 = UINavigationController(rootViewController: ComicBoxViewController())
        
    
        vc1.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc2.tabBarItem.image = UIImage(systemName: "books.vertical.fill")
     

        vc1.title = "Publishers"
        vc2.title = "Comic Box"
        
        tabBar.tintColor = .label

        setViewControllers([vc1, vc2], animated: true)
    }
}


