//
//  Publisher.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import Foundation

struct APIPublishersResponse: Codable { let results: [Publisher] }


struct Publisher: Codable, Hashable
{
    var publisherDetailsURL: String
    var id: Int
    var name: String
    var image: Image
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case name
        case publisherDetailsURL    = "api_detail_url"
        case image
    }
    
    func hash(into hasher: inout Hasher) { hasher.combine(name) }
}


struct Image: Codable, Equatable
{
    var iconURL: String
    
    enum CodingKeys: String, CodingKey
    {
        case iconURL                = "icon_url"
    }
}

