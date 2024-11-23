//
//  COAlertContainerView.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/4/24.
//

import UIKit

class COAlertContainerView: UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    private func configure()
    {
        backgroundColor                           = .systemBackground
        layer.cornerRadius                        = 16
        layer.borderWidth                         = 2
        layer.borderColor                         = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
