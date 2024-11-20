//
//  SearchVC+Ext.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/20/24.
//

import UIKit
extension SearchVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        UIImageView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.logoImageView.transform                        = self.logoImageView.transform.translatedBy(x: 0, y: -900)
        }, completion: { (_) in
            self.isPublisherEntered ? self.pushFilteredPublishersVC() : self.pushAllPublishersVC()
        })
        return true
    }
}
