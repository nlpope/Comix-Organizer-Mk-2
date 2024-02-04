//
//  Volume.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/3/24.
//

import Foundation
import UIKit

struct APIVolumesResponse: Decodable {
    let results: [Volume]
}

struct Volume: Decodable {
    var volumeID: Int
    var volumeName: String
    var volumePublisher: String
    var volumeDetailURL: String
    var volumeStartyear: String
    var volumeIssues: [Issue]
}
