//
//  Publisher.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import Foundation

struct APIPublishersResponse: Decodable {
    //below must be named 'results' as it "maps" to JSON's 'results'
    let results: [Publisher]
}

//for nested items, start w final dest. then declare wrapper prop(s) in enum(s)
struct Publisher: Decodable {
    var publisherDetailsURL: String
    var id: Int
    var publisherName: String
    
    //(a) start w plural "CodingKeys" for top level enums & expected nest name cases...
    //(b) then move to singular naming convention if nest delves even deeper - docs
    //(c) finally, after the enum setup, in your init(from decoder) - ...
    //link the top level key containing the nested container using the corresp. top level case - docs
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


