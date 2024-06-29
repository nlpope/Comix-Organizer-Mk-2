//
//  UIViewController+Ext.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/29/24.
//

import UIKit

extension UIViewController {
    
    func presentLoadingAnimationViewController() {
        let loadingAnimationVC = LoadAnimationViewController()
  //03.15: commented out - loadingAnimationVC.delegate = self
        
        //hide the navigation controller & tabs
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(loadingAnimationVC, animated: true)
    }
    
    func dismissLoadingAnimationViewController() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false

        self.navigationController?.popViewController(animated: true)
    }
}
