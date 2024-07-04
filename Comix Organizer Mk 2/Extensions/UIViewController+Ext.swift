//
//  UIViewController+Ext.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/29/24.
//

import UIKit

extension UIViewController {
    
    func presentCOAlertOnMainThread(alertTitle: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            // do stuff
        }
    }
    
    
    func presentLoadAnimationVC() {
        let loadAnimationVC = COLoadAnimationVC()
        
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
    
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView      = COEmptyStateView(message: message)
        emptyStateView.frame    = view.bounds
        view.addSubview(emptyStateView)
    }
}
