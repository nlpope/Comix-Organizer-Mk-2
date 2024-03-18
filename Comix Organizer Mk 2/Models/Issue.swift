//
//  Issue.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/3/24.
//

import Foundation
import UIKit

//umbrellaed under Volumes (or titles) from API
struct APIIssuesResponse: Decodable {
    let results: [String: [Issue]]
}

struct Issue: Decodable {
    var issueID: Int
    var issueName: String
    var issueDetailsURL: String
    
    enum CodingKeys: String, CodingKey {
        case issueID = "id"
        case issueName = "name"
        case issueDetailsURL = "api_detail_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        issueID = try container.decode(Int.self, forKey: .issueID)

        issueName = try container.decode(String.self, forKey: .issueName)

        issueDetailsURL = try container.decode(String.self, forKey: .issueDetailsURL)
        
    }
}


