//
//  UIViewController+Ext.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/29/24.
//

import UIKit

extension UIViewController {
    
    func addKeyboardDismissOnTap() {
        let endEditingTapGesture                    = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        endEditingTapGesture.cancelsTouchesInView   = false
        view.addGestureRecognizer(endEditingTapGesture)
    }
    
    func presentCOAlertOnMainThread(alertTitle: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = COAlertChildVC(alertTitle: alertTitle, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            
            self.present(alertVC, animated: true)
        }
    }
}
