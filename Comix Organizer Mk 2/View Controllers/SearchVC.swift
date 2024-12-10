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
    let logoImageView           = UIImageView()
    let searchTextField  = COTextField()
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
    
    
    @objc fileprivate func configureIntroPlayer()
    {
        guard let url              = Bundle.main.url(forResource: VideoKeys.launchScreen, withExtension: ".mp4") else { return }
        player                     = AVPlayer.init(url: url)
        playerLayer                = AVPlayerLayer(player: player)
        playerLayer?.videoGravity  = AVLayerVideoGravity.resizeAspect
        playerLayer?.frame         = view.layer.frame
        playerLayer?.name          = PlayerLayerKeys.layerName
        player?.actionAtItemEnd    = AVPlayer.ActionAtItemEnd.none
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
        } catch {
            print("unable to keep player from interrupting background music")
        }
        player?.play()
        
        view.layer.insertSublayer(playerLayer!, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
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
    
    
    @objc func setPlayerLayerToNil()
    {
        player?.pause()
        playerLayer    = nil
    }
    
    
    @objc func reinitializePlayerLayer()
    {
        guard isInitialLoad else { return }
        if let playerz      = player {
            playerLayer     = AVPlayerLayer(player: playerz)
            playerLayer?.name = PlayerLayerKeys.layerName
            
            if #available(iOS 10.0, *) { if playerz.timeControlStatus == .paused { playerz.play() } }
            else { if playerz.isPlaying == false { playerz.play() }}
        }
    }
    
    
    @objc func playerDidFinishPlaying()
    {
        removeAllAVPlayerLayers()
        isInitialLoad               = false
        DispatchQueue.main.async { [weak self] in self?.configureSearchVC() }
    }
    
    
    func addSubviews() { view.addSubviews(logoImageView, searchTextField, callToActionButton) }
    
    
    // MARK: HERO HOVER METHODS
    
    @objc func pauseAnimation() { animationDidPause   = true }
    
    
    @objc func resumeAnimation(){ guard animationDidPause else { return }; heroFlyIn() }
    
    
    func heroFlyIn()
    {
        UIImageView.animate(withDuration: 1,
                            delay: 0,
                            usingSpringWithDamping: 1,
                            initialSpringVelocity: 1,
                            options: .curveEaseOut,
                            animations: { self.logoImageView.transform  = CGAffineTransform(translationX: 0, y: -770) },
                            completion: { _ in self.heroHover(true) })
    }
    
    
    func heroHover(_ :Bool)
    {
        UIImageView.animate(withDuration: 1,
                            delay: 0,
                            options: [.repeat, .autoreverse],
                            animations: { self.logoImageView.transform = self.logoImageView.transform.translatedBy(x: 0, y: 50)})
    }
    
    
    #warning("if text field is empty, add a space for query to work with raw search press - @ final completion param")
    @objc func animateHeroFlyOut()
    {
        view.endEditing(true)
        UIImageView.animate(withDuration: 1,
                            delay: 0,
                            usingSpringWithDamping: 1,
                            initialSpringVelocity: 0.3,
                            options: .curveEaseInOut,
                            animations: { self.logoImageView.transform = self.logoImageView.transform.translatedBy(x: 0, y: -900) },
                            completion: { _ in self.isQueryEntered ? self.pushFilteredSearchVC() : print("nothing entered") })
    }
    
    
    func pushFilteredSearchVC()
    {
        searchTextField.resignFirstResponder()
        let query           = searchTextField.text!
//        Task { try await APICaller.shared.getAllResults(forQuery: query, page: 0) }
        let filteredPublishersVC    = FilteredSearchVC(withName: query)
        navigationController?.pushViewController(filteredPublishersVC, animated: true)
    }
}










