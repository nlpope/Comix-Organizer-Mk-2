//
//  Title.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/3/24.
//

import Foundation
import UIKit

struct APITitlesResponse: Codable
{
    let results: [String: [Title]]
}

struct Title: Codable, Hashable
{
    var name: String
    var id: Int
    var detailsURL: String
    
    enum CodingKeys: String, CodingKey
    {
        case name          = "name"
        case id            = "id"
        case detailsURL    = "api_detail_url"
    }
    
    init(from decoder: Decoder) throws
    {
        let container   = try decoder.container(keyedBy: CodingKeys.self)
        
        name            = try container.decode(String.self, forKey: .name)
        id              = try container.decode(Int.self, forKey: .id)
        detailsURL      = try container.decode(String.self, forKey: .detailsURL)
    }
    
    func hash(into hasher: inout Hasher) { hasher.combine(name) }
}
