//
//  COBodyLabel.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/4/24.
//

import UIKit

class COBodyLabel: UILabel
{
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    convenience init(textAlignment: NSTextAlignment)
    {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }
    
    
    private func configure()
    {
        textColor                                 = .secondaryLabel
        font                                      = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory         = true
        adjustsFontSizeToFitWidth                 = true
        minimumScaleFactor                        = 0.75
        lineBreakMode                             = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
