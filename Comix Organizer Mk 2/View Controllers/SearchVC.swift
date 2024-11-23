//
//  SearchVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/28/24.
//

import UIKit
import AVKit
import AVFoundation

#warning("get player to stop interrupting music")
// instructions: https://comicvine.gamespot.com/forums/api-developers-2334/simple-example-s-for-using-the-apis-1885345/

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
    
    
    func configureSearchVC()
    {
        configureNavigation()
        addSubviews()
        configureTextField()
        configureCallToActionButton()
        setupKeyboardHiding()
        addKeyboardDismissOnTap()
        configureLogoImageView()
    }
    
    
    func configureNotifications()
    {
        // LOGO PLAYER
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
        // HERO HOVER
        #warning("use a calayer approach here too?")
        NotificationCenter.default.addObserver(self, selector: #selector(pauseAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeAnimation), name: UIApplication.didBecomeActiveNotification, object: nil)
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
    fileprivate func removeAllAVPlayerLayers()
    {
        if let layers = view.layer.sublayers {
            for (i, layer) in layers.enumerated() {
                if layer.name == PlayerLayerKeys.layerName {
                    layers[i].removeFromSuperlayer()
                }
            }
        }
    }
    
    
    @objc fileprivate func setPlayerLayerToNil()
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
    
    
    @objc fileprivate func playerDidFinishPlaying()
    {
        removeAllAVPlayerLayers()
        isInitialLoad               = false
        DispatchQueue.main.async { [weak self] in self?.configureSearchVC() }
    }
    
    
    // MARK: HERO HOVER METHODS
    @objc func pauseAnimation() { animationDidPause   = true }
    
    
    @objc func resumeAnimation()
    {
        guard animationDidPause else { return }
        UIImageView.animate(withDuration: 1,
                            delay: 0,
                            usingSpringWithDamping: 1,
                            initialSpringVelocity: 1,
                            options: .curveEaseOut,
                            animations: {
            self.logoImageView.transform                            = CGAffineTransform(translationX: 0, y: -770)
        }) { _ in
            UIImageView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
                self.logoImageView.transform                        = self.logoImageView.transform.translatedBy(x: 0, y: 40)
            }
        }
    }
    
    
    func configureNavigation()
    {
        self.navigationController?.navigationBar.isHidden       = true
        self.tabBarController?.tabBar.isHidden                  = false
        searchTextField.text                             = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor                                    = .systemBackground
        title                                                   = "Search"
        navigationController?.navigationBar.prefersLargeTitles  = true
    }
    
    
    func addSubviews() { view.addSubviews(logoImageView, searchTextField, callToActionButton) }
    
    
    func configureTextField()
    {
        let paddingView: UIView                 = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
        searchTextField.delegate         = self
        searchTextField.placeholder      = PlaceHolderKeys.searchPlaceHolder
        searchTextField.leftView         = paddingView
        searchTextField.rightView        = paddingView
        searchTextField.leftViewMode     = .always
        searchTextField.rightViewMode    = .always
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: callToActionButton.topAnchor, constant: -75),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureCallToActionButton()
    {
        callToActionButton.backgroundColor  = UIColor(red: 0.81, green: 0.71, blue: 0.23, alpha: 1.0)
        callToActionButton.setTitle("GO", for: .normal)
        callToActionButton.addTarget(self, action: #selector(pushAllOrFilteredPublishersVC), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureLogoImageView()
    {
        logoImageView.translatesAutoresizingMaskIntoConstraints     = false
        logoImageView.image                                         = ImageKeys.coLogo
        logoImageView.layer.zPosition                               = -1
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 950),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 350),
            logoImageView.heightAnchor.constraint(equalToConstant: 350)
        ])
                
        UIImageView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.logoImageView.transform                            = CGAffineTransform(translationX: 0, y: -770)
        }) { (_) in
            UIImageView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
                self.logoImageView.transform                        = self.logoImageView.transform.translatedBy(x: 0, y: 40)
            }
        }
    }
    
    
    @objc func pushAllOrFilteredPublishersVC()
    {
        view.endEditing(true)
        UIImageView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.logoImageView.transform                        = self.logoImageView.transform.translatedBy(x: 0, y: -900)
        }, completion: { (_) in
            self.isQueryEntered ? self.pushGenericSearchVC() : self.pushAllPublishersVC()
        })
    }
    
    
    func pushGenericSearchVC()
    {
        searchTextField.resignFirstResponder()
        let query           = searchTextField.text!
//        Task { try await APICaller.shared.getSearchResults(forQuery: query, page: 0) }
        let filteredPublishersVC    = FilteredPublishersVC(withName: query)
        navigationController?.pushViewController(filteredPublishersVC, animated: true)
    }
    
    
    func pushAllPublishersVC()
    {
        searchTextField.resignFirstResponder()
        let allPublishersVC = AllPublishersVC()
        navigationController?.pushViewController(allPublishersVC, animated: true)
    }
}










