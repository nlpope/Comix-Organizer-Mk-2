//
//  COAvatarImageView.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/1/24.
//

#warning("change blank img to hero logo - think it has sumn to do w the assets folder's avatarplaceholder")
import UIKit

class COAvatarImageView: UIImageView
{
    let cache               = APICaller.shared.cache
    let placeholderImage    = ImageKeys.placeholder
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    private func configure()
    {
        layer.cornerRadius                          = 10
        clipsToBounds                               = true
        image                                       = placeholderImage
        translatesAutoresizingMaskIntoConstraints   = false
    }
    
    
    func downloadImage(fromURL url: String)
    {
        APICaller.shared.downloadImage(from: url)
        { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
