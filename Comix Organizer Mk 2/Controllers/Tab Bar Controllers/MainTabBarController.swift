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
        setVCs()
        configureTabBar()
    }
    
    
    func configureTabBar() { tabBar.tintColor = .label }
    
    
    func setVCs() { viewControllers = [createStartNC(), createComixBinNC()] }
    
    
    func createStartNC() -> UINavigationController {
        let startVC = StartVC()
        startVC.title = "ComixOrganizer"
        startVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: startVC)
    }
    
    
    func createComixBinNC() -> UINavigationController {
        let comixBinVC = ComixBinVC()
        comixBinVC.title = "ComixBin"
        comixBinVC.tabBarItem.image = UIImage(systemName: "books.vertical.fill")

        return UINavigationController(rootViewController: comixBinVC)
    }
}


