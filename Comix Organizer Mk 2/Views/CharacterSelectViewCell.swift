//
//  CharacterSelectViewCell.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 12/18/23.
//

import Foundation
import UIKit

class CharacterSelectViewCell: UITableViewCell {
    static let identifier = "CharacterSelectViewCell"
    
    //giving CharacterSelectVC label & image
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterThumbnailUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public func configureWith(character: String) {
        //should contain character image
        
        
        
    }
}
