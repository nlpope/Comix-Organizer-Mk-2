//
//  SearchVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/28/24.
//

import UIKit
import AVKit
import AVFoundation

class SearchVC: UIViewController
{
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var isQueryEntered: Bool { return !searchTextField.text!.isEmpty }
    var isInitialLoad           = true
    var animationDidPause       = false
    var heroFlewUp              = false
    let logoImageView           = UIImageView()
    let searchTextField         = COTextField()
    let callToActionButton      = COButton()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        maskSearchVC()
        configureNotifications()
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if isInitialLoad { configureIntroPlayer() }
        else { configureSearchVC() }
    }
    
    
    fileprivate func maskSearchVC()
    {
        view.backgroundColor = .black
        self.tabBarController?.tabBar.isHidden              = true
        self.navigationController?.navigationBar.isHidden   = true
    }
    
    
    deinit
    {
        print("deinit reached")
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        removeAllAVPlayerLayers()
        playerLayer        = nil
    }
    
    
    // MARK: AVPLAYER METHODS
    
    func removeAllAVPlayerLayers()
    {
        if let layers = view.layer.sublayers
        {
            for (i, layer) in layers.enumerated()
            {
                if layer.name == PlayerLayerKeys.layerName { layers[i].removeFromSuperlayer() }
            }
        }
    }
    
    
    @objc func setPlayerLayerToNil() { player?.pause(); playerLayer = nil }
    
    
    @objc func reinitializePlayerLayer()
    {
        guard isInitialLoad else { return }
        if let playerz      = player
        {
            playerLayer         = AVPlayerLayer(player: playerz)
            playerLayer?.name   = PlayerLayerKeys.layerName
            
            if #available(iOS 10.0, *) { if playerz.timeControlStatus == .paused { playerz.play() } }
            else { if playerz.isPlaying == false { playerz.play() }}
        }
    }
    
    
    func addSubviews() { view.addSubviews(logoImageView, searchTextField, callToActionButton) }
    
    
    // MARK: HERO HOVER METHODS
    
    @objc func pauseAnimation() { animationDidPause   = true }
    
    
    @objc func resumeAnimation()
    {
        guard animationDidPause else { return }
        heroLand()
    }
    
    
    func heroLand()
    {
        UIImageView.animate(withDuration: 1,
                            delay: 0,
                            usingSpringWithDamping: 1,
                            initialSpringVelocity: 1,
                            options: .curveEaseOut,
                            animations: { self.logoImageView.transform  = CGAffineTransform(translationX: 0, y: 950) },
                            completion: { _ in
            self.heroHover(true)
            if self.heroFlewUp
            {
                self.fadeInTextFieldAndGoButton()
                self.heroFlewUp     = false
            }
        })
    }
    
    
    func heroHover(_ :Bool)
    {
        UIImageView.animate(withDuration: 1,
                            delay: 0,
                            options: [.repeat, .autoreverse],
                            animations: { self.logoImageView.transform = self.logoImageView.transform.translatedBy(x: 0, y: 50)})
    }
    
    
    @objc func heroFlyUp()
    {
        view.endEditing(true)
        UIImageView.animate(withDuration: 1,
                            delay: 0,
                            usingSpringWithDamping: 1,
                            initialSpringVelocity: 0.3,
                            options: .curveEaseInOut,
                            animations: { self.logoImageView.transform = self.logoImageView.transform.translatedBy(x: 0, y: -900) },
                            completion: { _ in self.heroFlewUp = true; self.pushFilteredSearchVC() })
    }
    
    
    func pushFilteredSearchVC()
    {
        searchTextField.resignFirstResponder()
        if !isQueryEntered { searchTextField.text = " " }
        let query           = searchTextField.text!
        let filteredPublishersVC    = FilteredSearchVC(withName: query)
        navigationController?.pushViewController(filteredPublishersVC, animated: true)
    }
}
