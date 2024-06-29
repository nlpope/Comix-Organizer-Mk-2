//
//  COError+Utils.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/29/24.
//

import Foundation

enum COError: String, Error {
    case invalidURL = "The URL passed is invalid."
    case failedToGetData = "Failed to get the data."
}
