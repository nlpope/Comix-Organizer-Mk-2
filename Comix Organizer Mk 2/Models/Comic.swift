//
//  Comic.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import Foundation

struct MetronComicsResponse: Codable {
    let results: [Comic]
}

struct Comic: Codable {
    let id: Int
    let publisher: Publisher?
    let title: String
    let issue: Int
    let releaseDate: Date?
    var completed: Bool = false
  
}
