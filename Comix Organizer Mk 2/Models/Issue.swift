//
//  Issue.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/3/24.
//

import UIKit

// umbrellaed under Volumes (or titles) from API
struct APIIssuesResponse: Codable {
    let results: [String: [Issue]]
}

struct Issue: Codable {
    var issueDetailsURL: String
    var issueID: Int
    var issueName: String
    var issueNumber: String
    var isFinished: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case issueID            = "id"
        case issueName          = "name"
        case issueDetailsURL    = "api_detail_url"
        case issueNumber        = "issue_number"
    }
}


