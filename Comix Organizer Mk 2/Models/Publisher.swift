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
    var image: Image
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case publisherDetailsURL    = "api_detail_url"
        case image
    }
}

struct Image: Decodable, Hashable {
    var iconURL: String
    
    enum CodingKeys: String, CodingKey {
        case iconURL                = "icon_url"
    }
}



// see note 1a & 1b in app delegate > used to be in publisher struct but pulled out for inclusion of Image struct
// https://anjalijoshi2426.medium.com/fetch-data-from-nested-json-in-api-in-swift-629e67fe8269




