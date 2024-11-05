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
    
    
    // MARK: SOLVE FOR KEYBOARD BLOCKING TEXTFIELD
    func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentResponder() as? UITextField else { return }
        
        let keyboardTopY        = keyboardFrame.cgRectValue.origin.y
        let textFieldBottomY    = currentTextField.frame.origin.y + currentTextField.frame.size.height
        
        if textFieldBottomY > keyboardTopY {
            let textFieldTopY   = currentTextField.frame.origin.y
            let newFrameY       = (textFieldTopY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }
    }
    
    
    @objc func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = 0
    }
}
