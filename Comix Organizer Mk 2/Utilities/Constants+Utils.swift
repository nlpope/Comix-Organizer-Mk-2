//
//  Constants+Utils.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/29/24.
//

import UIKit

enum NetworkCallKeys { static let API_KEY   = "b31d5105925e7fd811a07d63e82320578ba699f1" }

enum SFSymbolKeys {
    static let search               = UIImage(systemName: "magnifyingglass")
    static let bookShelf            = UIImage(systemName: "books.vertical.fill")
    static let add                  = UIImage(systemName: "rectangle.stack.fill.badge.plus")
    static let subtract             = UIImage(systemName: "rectangle.stack.fill.badge.minus")
}

enum ImageKeys {
    static let coLogo               = UIImage(named: "co-logo")
    static let placeholder          = UIImage(named: "avatar-placeholder")
    static let emptyStateLogo       = UIImage(named: "empty-state-logo")
}

enum PlaceHolderKeys {
    static let searchPlaceHolder    = "Enter publisher or hit GO to see all"
}

enum MessageKeys {
    static let titleAdded           = "You have successfully saved this title to your ComixBin 🥳."
    static let titleRemoved         = "You have successfully removed this title from your ComixBin."
    static let issueCompleted       = "Hope you enjoyed reading this issue. It was saved to your completed list  🥳."
    static let issueIncomplete      = "This issue has been marked incomplete."
}
