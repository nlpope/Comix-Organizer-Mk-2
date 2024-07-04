//
//  UIView+Ext.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/3/24.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
