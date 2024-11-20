//
//  MainTabBarViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/8/23.
//

import UIKit

class COTabBarController: UITabBarController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureTabBar()
        setVCs()
    }
    
    
    func configureTabBar() { tabBar.tintColor = .label }
    
    
    func setVCs() { viewControllers = [createSearchNC(), createComixBinNC()] }
    
    
    func createSearchNC() -> UINavigationController
    {
        let searchVC                 = SearchVC()
        searchVC.title               = "Search"
        searchVC.tabBarItem.image    = SFSymbolKeys.search
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    
    func createComixBinNC() -> UINavigationController
    {
        let comixBinVC              = ComixBinVC()
        comixBinVC.title            = "ComixBin"
        comixBinVC.tabBarItem.image = SFSymbolKeys.bookShelf

        return UINavigationController(rootViewController: comixBinVC)
    }
}


