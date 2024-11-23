//
//  ResourceBundle.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/23/24.
//

// https://comicvine.gamespot.com/api/search/?api_key=b31d5105925e7fd811a07d63e82320578ba699f1&offset=3&format=json&field_list=name&sort=name:asc&resources=publisher,character,volume&query=%22archie%22
import UIKit

struct APIResourceBundleResponse: Codable { let results: [ResourceBundle] }

struct ResourceBundle: Codable, Hashable
{
    var resourceDetailsURL: String
    var id: Int
    var name: String
    var image: Image
    var resourceType: String
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case name
        case resourceDetailsURL     = "api_detail_url"
        case image
        case resourceType           = "resource_type"
    }
    
    func hash(into hasher: inout Hasher) { hasher.combine(name) }
    
    struct Image: Codable, Equatable
    {
        var iconURL: String
        
        enum CodingKeys: String, CodingKey
        {
            case iconURL                = "icon_url"
        }
    }
}
