//
//  AVPlayer+Ext.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/20/24.
//

import Foundation
import AVFoundation

extension AVPlayer
{
    var isPlaying: Bool { return rate != 0 && error == nil }
}
