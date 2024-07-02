//
//  COAvatarImageView.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/1/24.
//

import UIKit

class COAvatarImageView: UIImageView {
    #warning("previously on: make placeholder from assets > enums in Utils > set up your cache in the apicaller/networkmanager > noahpope.me portfolio after checking hostgator progress")
//    let cache               = APICaller.shared.cache
    let placeholderImage    = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius                          = 10
        clipsToBounds                               = true
        image                                       = placeholderImage
        translatesAutoresizingMaskIntoConstraints   = false
    }
    
    
    func downloadImage(fromURL url: String) {
        
    }
}
