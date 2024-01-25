//
//  MainTabBarViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/8/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    public var selectedPublisher = ""
    public var selectedPublisherDetailsURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: AllPublishersViewController())
        let vc2 = UINavigationController(rootViewController: AllCharactersViewController(selectedPublisherDetailsURL: selectedPublisherDetailsURL))
        let vc3 = UINavigationController(rootViewController: AllTeamsViewController())
        let vc4 = UINavigationController(rootViewController: AllComicsViewController())
        
        
        vc1.tabBarItem.image = UIImage(systemName: "list.dash")
        vc2.tabBarItem.image = UIImage(systemName: "person.fill")
        vc3.tabBarItem.image = UIImage(systemName: "person.3.fill")
        vc4.tabBarItem.image = UIImage(systemName: "book.fill")


        vc1.title = "Publishers"
        vc2.title = "\(selectedPublisher) Characters"
        vc3.title = "\(selectedPublisher) Teams"
        vc4.title = "\(selectedPublisher) Issues"
        
        
        
        tabBar.tintColor = .label

        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}


