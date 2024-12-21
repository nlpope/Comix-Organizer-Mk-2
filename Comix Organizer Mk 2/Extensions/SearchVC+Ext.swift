//
//  SearchVC+Ext.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/20/24.
//

import UIKit
import AVFoundation
extension SearchVC: UITextFieldDelegate
{
    // MARK: CONFIGURATION LOGIC
    
    @objc func configureIntroPlayer()
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
    
    
    @objc func playerDidFinishPlaying()
    {
        removeAllAVPlayerLayers()
        DispatchQueue.main.async { [weak self] in self?.configureSearchVC() }
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
    
    
    func configureNavigation()
    {
        self.navigationController?.navigationBar.isHidden       = true
        self.tabBarController?.tabBar.isHidden                  = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor                                    = .systemBackground
        navigationController?.navigationBar.backItem?.title     = "Search"
        navigationController?.navigationBar.prefersLargeTitles  = true
    }
    
    
    func configureNotifications()
    {
        // LOGO PLAYER
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
        // HERO HOVER
        NotificationCenter.default.addObserver(self, selector: #selector(pauseAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeAnimation), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    func configureTextField()
    {
        let paddingView: UIView         = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
        searchTextField.delegate        = self
        searchTextField.placeholder     = PlaceHolderKeys.searchPlaceHolder
        searchTextField.leftView        = paddingView
        searchTextField.rightView       = paddingView
        searchTextField.leftViewMode    = .always
        searchTextField.rightViewMode   = .always
        searchTextField.text            = ""
        
        if heroFlewUp || isInitialLoad { searchTextField.alpha = 0 }
        
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
        callToActionButton.addTarget(self, action: #selector(fadeOutTextFieldAndGoButton), for: .touchUpInside)
        if heroFlewUp || isInitialLoad { callToActionButton.alpha = 0 }

        
        
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
            logoImageView.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: -770),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 350),
            logoImageView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        heroLand()
    }
    
    
    // MARK: TEXTFIELD DELEGATE & COMPLIMENTARY METHODS
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        fadeOutTextFieldAndGoButton()
        return true
    }
    
    
    func fadeInTextFieldAndGoButton()
    {
        UITextField.animate(withDuration: 1) { self.searchTextField.alpha = 1 }
        UIButton.animate(withDuration: 1) { self.callToActionButton.alpha = 1 }
    }
    
    
    func fadeInGoButton() { UIButton.animate(withDuration: 1) { self.callToActionButton.alpha = 1 } }
    
    
    @objc func fadeOutTextFieldAndGoButton()
    {
        defer { heroFlyUp() }
        UITextField.animate(withDuration: 1) { self.searchTextField.alpha = 0 }
        UIButton.animate(withDuration: 1) { self.callToActionButton.alpha = 0 }
    }
}
