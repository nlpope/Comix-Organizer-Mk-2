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

#warning("making Publisher model 'Hashable' for diffable data source implem.")
// see note 2 in app delegate
struct Publisher: Decodable, Hashable {
    var publisherDetailsURL: String
    var id: Int
    var publisherName: String
    
    // see note 1 in app delegate
    enum CodingKeys: String, CodingKey {
        case publisherDetailsURL = "api_detail_url"
        case id
        case publisherName = "name"
    }
}


