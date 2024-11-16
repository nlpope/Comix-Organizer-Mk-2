//
//  LaunchScreenPlayer.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/16/24.
//

import UIKit
import AVFoundation

class LaunchScreenPlayer: UIViewController {
    
    var player: AVPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadVideo()
    }
    
    
    private func loadVideo()
    {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }
        
//        if let path = Bundle.main.url(forResource: <#T##String?#>, withExtension: "mp4")
    }
}

