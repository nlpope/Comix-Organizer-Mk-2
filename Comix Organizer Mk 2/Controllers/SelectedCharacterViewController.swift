//
//  SelectedCharacterViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 12/27/23.
//

import Foundation
import UIKit

class SelectedCharacterViewController: UIViewController {
    
    private var character: String
    
    init(selectedCharacter: String) {
        self.character = selectedCharacter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
