//
//  COError+Utils.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/29/24.
//

import Foundation

enum COError: String, Error {
    case invalidURL             = "The URL passed is invalid."
    case failedToGetData        = "Failed to get the data."
    #warning("replace error msgs in empty states with below")
    case unableToBookmark       = "There was a problem adding this title to your ComixBin. Please try again."
    case alreadyInBookmarx      = "You've already added this title to your ComixBin."
    case failedToRecordCompletion = "We were unable to record this completion. Please try again."
    case failedToLoadProgress   = "We were unable to retrieve your progress from your last visit. Your progress will be reset. If the issue persists, please notify the developer."
    
}
