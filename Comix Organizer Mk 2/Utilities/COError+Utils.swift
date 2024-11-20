//
//  COError+Utils.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/29/24.
//

import Foundation

enum COError: String, Error
{
    case invalidURL             = "The URL passed is invalid."
    case failedToGetData        = "Failed to get the data."
    case unableToBookmark       = "There was a problem adding this title to your ComixBin. Please try again."
    case unableToLoadBookmarx   = "There was a problem loading one or more titles from your ComixBin. Please try again."
    case alreadyInBookmarx      = "You've already added this title to your ComixBin."
    
    case failedToSaveProgress   = "We were unable to save your progress. Please try again."
    case failedToLoadProgress   = "We were unable to load your progress from your last visit. Your progress will be reset. If the issue persists, please notify the developers."
    
}
