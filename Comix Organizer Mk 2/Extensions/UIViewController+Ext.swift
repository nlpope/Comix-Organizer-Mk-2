//
//  UIViewController+Ext.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/29/24.
//

import UIKit

extension UIViewController {
    
    func presentLoadAnimationVC() {
        let loadAnimationVC = LoadAnimationVC()
//        loadingAnimationVC.delegate = self
        
        // hide nav controller & tabs
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(loadAnimationVC, animated: true)
    }
    
    func dismissLoadAnimationVC() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
}
