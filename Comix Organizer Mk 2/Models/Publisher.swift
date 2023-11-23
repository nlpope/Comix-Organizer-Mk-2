//
//  Publisher.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import Foundation

struct MetronPublishersResponse: Codable {
    let results: [Publisher]
}

struct Publisher: Codable {
    let id: Int
    let name: String?
    let modified: Date?
    
    
    //how to get array of publisher's comics (type Comic)
    //in here AND in the PublisherItem data model
}
