//
//  CharacterSelectViewCell.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 12/18/23.
//

import Foundation
import UIKit

class CharacterSelectViewCell: UITableViewCell {
    @IBOutlet var characterName: UILabel?
    @IBOutlet var characterAbbreviatedBio: UILabel?
    @IBOutlet var characterDetailedBio: UILabel?
    @IBOutlet var characterThumbnail: UIImageView?
    
    static let identifier = "CharacterSelectViewCell"
    
    
    
    //giving CharacterSelectVC label & image
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterThumbnailUIImageView: UIImageView = {
        let imageView = UIImageView()
        //not sure if the below is right
        //read docs @ "Configure a cell with custom views"
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
}
