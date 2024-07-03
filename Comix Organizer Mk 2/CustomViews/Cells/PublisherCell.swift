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
        publisherNameLabel.text = publisher.name
        avatarImageView.downloadImage(fromURL: publisher.avatarURL)
    }
    
    
    func configure() {
        addSubviews(avatarImageView, publisherNameLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            publisherNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            publisherNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            publisherNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            publisherNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
