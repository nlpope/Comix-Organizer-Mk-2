//
//  PublisherCell.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/1/24.
//

import UIKit

class PublisherCell: UICollectionViewCell {
    
    static let reuseID      = "PublisherCell"
    let avatarImageView     = COAvatarImageView(frame: .zero)
    let publisherNameLabel  = COTitleLabel(textAlignment: .center, fontSize: 16)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(publisher: Publisher) {
        publisherNameLabel.text = publisher.publisherName
        avatarImageView
    }
    
    
    func configure() {
        
    }
}
