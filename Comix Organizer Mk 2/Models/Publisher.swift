//
//  Publisher.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import Foundation

struct MetronPublishersResponse: Codable {
    let results: [Publisher]
}

struct Publisher: Codable {
    let id: Int
    let name: String
    let comics: [Comic]
}
