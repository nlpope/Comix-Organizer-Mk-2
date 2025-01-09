//
//  COSearchTabBarController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 1/6/25.
//

import UIKit

class COSearchTabBarController: UITabBarController
{
    
    var queryContains: String!
    
//    init(withName name: String)
//    {
//        defer { print("initializer reached and = \(queryContains)") }
//        super.init(nibName: nil, bundle: nil)
//        self.queryContains = name
//    }
//    
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        configureTabBar()
        setVCs()
        
    }
    
    
    func configureTabBar() { tabBar.tintColor = .red }
    
    
    func setVCs() { viewControllers = [createPublisherSearchNC(), createCharacterNC(), createTitleNC(), createIssueNC()] }
    
    
    func createPublisherSearchNC() -> UINavigationController
    {
        #warning("post-echo read into uitabbarcontroller docs & why global var cant reach here")
        print("query containz = \(queryContains)")
        let publisherSearchVC                 = PublisherSearchVC(withName: s)
        publisherSearchVC.title               = "Publishers"
        publisherSearchVC.tabBarItem.image    = SFSymbolKeys.publisher
        
        return UINavigationController(rootViewController: publisherSearchVC)
    }
    
    
    func createCharacterNC() -> UINavigationController
    {
        let characterSearchVC                 = CharacterSearchVC(withName: "spider")
        characterSearchVC.title               = "Characters"
        characterSearchVC.tabBarItem.image    = SFSymbolKeys.character
        
        return UINavigationController(rootViewController: characterSearchVC)
    }
    
    
    func createTitleNC() -> UINavigationController
    {
        let titleSearchVC              = TitleSearchVC(withName: "spider")
        titleSearchVC.title            = "Titles"
        titleSearchVC.tabBarItem.image = SFSymbolKeys.title

        return UINavigationController(rootViewController: titleSearchVC)
    }
    
    
    func createIssueNC() -> UINavigationController
    {
        let issueSearchVC              = IssueSearchVC(withName: "spider")
        issueSearchVC.title            = "Issues"
        issueSearchVC.tabBarItem.image = SFSymbolKeys.issue

        return UINavigationController(rootViewController: issueSearchVC)
    }
}


