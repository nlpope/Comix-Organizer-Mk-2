//
//  Publisher.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import Foundation

struct APIPublishersResponse: Decodable {
    //below must be named 'results'
    //b/c it mimics JSON's 'results'
    let results: [Publisher]
}

//FORMER PROBLEM CHILD
//source of dictonary type mismatch
struct Publisher: Decodable {
    var publisherDetailsURL: String
    var id: Int
    var publisherName: String
    
    enum CodingKeys: String, CodingKey {
        case publisherDetailsURL = "api_detail_url"
        case id
        case publisherName = "name"
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.publisherDetailsURL = try container.decodeIfPresent(URL.self, forKey: .publisherDetailsURL)
//        self.id = try container.decode(Int.self, forKey: .id)
//        self.publisherName = try container.decode(String.self, forKey: .publisherName)
//    }
}


