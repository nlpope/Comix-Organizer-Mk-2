//
//  Publisher.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import Foundation

struct APIPublishersResponse: Decodable, Hashable {
    // see note 3 in app delegate
    let results: [Publisher]
}

// see note 2 in app delegate
struct Publisher: Decodable, Hashable {
    var publisherDetailsURL: String
    var id: Int
    var name: String
    var avatarURL: String
    
    // see note 1 in app delegate
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case publisherDetailsURL    = "api_detail_url"
        case avatarURL              = "icon_url"
    }
}


