//
//  CharacterSelectViewCell.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 12/18/23.
//

import Foundation
import UIKit

class CharacterSelectViewCell: UITableViewCell {
    @IBOutlet var characterViewCellName: UILabel?
    @IBOutlet var characterViewCellAbbreviatedBio: UILabel?
    @IBOutlet var characterViewCellDetailedBio: UILabel?
    @IBOutlet var characterViewCellThumbnail: UIImageView?
    //Add outlets to your subclass and connect those outlets to the corresponding views in your prototype cell
    
    static let identifier = "CharacterSelectViewCell"
    
}
