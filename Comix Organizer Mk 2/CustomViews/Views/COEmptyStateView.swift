//
//  COEmptyStateView.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/4/24.
//

import UIKit

class COEmptyStateView: UIView
{
    let messageLabel    = COTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView   = UIImageView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubviews(messageLabel, logoImageView)
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    convenience init(message: String)
    {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    
    private func configure()
    {
        configureMessageLabel()
        configureLogoImageView()
    }
    
    
    private func configureMessageLabel()
    {
        messageLabel.numberOfLines  = 3
        messageLabel.textColor      = .secondaryLabel
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    
    private func configureLogoImageView()
    {
        logoImageView.image         = ImageKeys.emptyStateLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 270),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40)
        ])
    }
}
