//
//  Publisher.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import Foundation

struct APIPublishersResponse: Codable {
    // see note 3 in app delegate
    let results: [Publisher]
}

// see note 2 in app delegate
struct Publisher: Codable, Hashable {
    
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
    
    #warning("changing haser.combine's param from name to id + added stubs for equatable conformance")
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // see note 13 in app delegate
    static func == (lhs: Publisher, rhs: Publisher) -> Bool {
        return lhs.name == rhs.name &&
        lhs.publisherDetailsURL == rhs.publisherDetailsURL &&
        lhs.id == rhs.id &&
        lhs.image == rhs.image
    }
}

// (since deleted, but still relevatn) - adding Equatable here negates need for that == lhs/rhs func in Publisher struct, b/c all stored props in struct must conform to Equatable: most types are but you include a custom type (Image) within it as well, which isn't automatically Equatable
struct Image: Codable, Equatable {
    var iconURL: String
    
    enum CodingKeys: String, CodingKey {
        case iconURL                = "icon_url"
    }
}

