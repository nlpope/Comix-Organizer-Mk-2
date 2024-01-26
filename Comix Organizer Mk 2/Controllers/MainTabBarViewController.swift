//
//  MainTabBarViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/8/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    //think this is still empty when the configureCharacters call is made. how to update this / make it a computed prop? do computed props work for UITabBarControllers?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: AllPublishersViewController())
        let vc2 = UINavigationController(rootViewController: AllCharactersViewController())
        let vc3 = UINavigationController(rootViewController: AllTeamsViewController())
        let vc4 = UINavigationController(rootViewController: AllComicsViewController())
        
        
        vc1.tabBarItem.image = UIImage(systemName: "list.dash")
        vc2.tabBarItem.image = UIImage(systemName: "person.fill")
        vc3.tabBarItem.image = UIImage(systemName: "person.3.fill")
        vc4.tabBarItem.image = UIImage(systemName: "book.fill")

        //wanna put the Publisher in front of VCs 2-4
        vc1.title = "Publishers"
        vc2.title = "Characters"
        vc3.title = "Teams"
        vc4.title = "Issues"
        
        tabBar.tintColor = .label

        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}


