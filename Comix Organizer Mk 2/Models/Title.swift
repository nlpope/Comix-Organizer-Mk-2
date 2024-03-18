//
//  Title.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/3/24.
//

import Foundation
import UIKit

//titles = volumes in the API
struct APITitlesResponse: Decodable {
    let results: [String: [Title]]
}

struct Title: Decodable {
    var titleID: Int
    var titleName: String
    var titleDetailsURL: String
    //    var volumeIssues: [Issue]
    
    enum CodingKeys: String, CodingKey {
        case titleID = "id"
        case titleName = "name"
        case titleDetailsURL = "api_detail_url"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        titleID = try container.decode(Int.self, forKey: .titleID)

        titleName = try container.decode(String.self, forKey: .titleName)

        titleDetailsURL = try container.decode(String.self, forKey: .titleDetailsURL)
                
    }
}
