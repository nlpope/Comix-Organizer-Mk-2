//
//  COError+Utils.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/29/24.
//

import Foundation

enum COError: String, Error {
    case invalidURL         = "The URL passed is invalid."
    case failedToGetData    = "Failed to get the data."
    #warning("replace error msgs in empty states with below")
    case noPublishedTitles  = ""
    case unableToBookmark   = "There was a problem adding this title to your ComixBin. Please try again."
    case alreadyInBookmarx  = "You've already added this title to your ComixBin."
    
}
