//
//  MainTabBarViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/8/23.
//

import UIKit

class COTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVCs()
        configureTabBar()
    }
    
    
    func configureTabBar() { tabBar.tintColor = .label }
    
    
    func setVCs() { viewControllers = [createStartNC(), createComixBinNC()] }
    
    
    func createStartNC() -> UINavigationController {
        let startVC                 = SearchVC()
        // ComixOrganizer word under search image not updating
        startVC.title               = "Search"
        startVC.tabBarItem.image    = SFSymbols.search
        
        return UINavigationController(rootViewController: startVC)
    }
    
    
    func createComixBinNC() -> UINavigationController {
        let comixBinVC              = ComixBinVC()
        comixBinVC.title            = "ComixBin"
        comixBinVC.tabBarItem.image = SFSymbols.bookShelf

        return UINavigationController(rootViewController: comixBinVC)
    }
}


