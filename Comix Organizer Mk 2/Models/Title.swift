//
//  Title.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/3/24.
//

import Foundation
import UIKit

struct APIVolumesResponse: Decodable {
    let results: [String: [Title]]
}

struct Title: Decodable {
    var volumeID: Int
    var volumeName: String
    var volumeDetailsURL: String
    //    var volumeIssues: [Issue]
    
    enum CodingKeys: String, CodingKey {
        case volumeID = "id"
        case volumeName = "name"
        case volumeDetailURL = "api_detail_url"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        volumeDetailsURL = try container.decode(String.self, forKey: .volumeDetailURL)
        
        volumeID = try container.decode(Int.self, forKey: .volumeID)
        
        volumeName = try container.decode(String.self, forKey: .volumeName)
    }
}
