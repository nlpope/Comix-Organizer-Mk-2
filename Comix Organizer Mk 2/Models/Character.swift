//
//  Character.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 12/20/23.
//

import Foundation

struct APICharactersResponse: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
    //how to get image in here? UIImage throws error for codable protocol
}
