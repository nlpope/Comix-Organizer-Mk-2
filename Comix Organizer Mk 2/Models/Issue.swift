//
//  Issue.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/3/24.
//

import UIKit

// umbrellaed under Volumes (or titles) from API
struct APIIssuesResponse: Codable { let results: [String: [Issue]] }

struct Issue: Codable, Comparable
{
    static func < (lhs: Issue, rhs: Issue) -> Bool { return lhs.name < rhs.name }
    
    var name: String
    var id: Int
    var detailsURL: String
    var number: String
    
    enum CodingKeys: String, CodingKey
    {
        case name          = "name"
        case id            = "id"
        case detailsURL    = "api_detail_url"
        case number        = "issue_number"
    }
}


