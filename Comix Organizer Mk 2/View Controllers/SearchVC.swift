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
    
    var playerController : AVPlayerViewController!
    var isPublisherEntered: Bool { return !publisherNameTextField.text!.isEmpty }
    var isInitialLoad           = true
    let logoImageView           = UIImageView()
    let publisherNameTextField  = COTextField()
    let callToActionButton      = COButton(backgroundColor: .blue, title: "Get Publishers")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNotifications()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if isInitialLoad { playLaunchAnimation() }
        publisherNameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        configureNavigation()
        addSubviews()
        configureTextField()
        configureCallToActionButton()
        setupKeyboardHiding()
        addKeyboardDismissOnTap()
        configureLogoImageView()
    }
    
    
    func playLaunchAnimation()
    {
        isInitialLoad                           = false
        guard let path                          = Bundle.main.path(forResource: VideoKeys.launchScreen, ofType: "mp4") else { debugPrint("launchscreen.mp4 not found"); return }
        let player                              = AVPlayer(url: URL(fileURLWithPath: path))
        playerController                        = AVPlayerViewController()

        
        playerController.player = player
        playerController.showsPlaybackControls  = false
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: playerController.player?.currentItem)

        present(playerController, animated: false) { player.play() }
    }
    
    
    @objc func playerDidFinishPlaying() { self.playerController.dismiss(animated: false) }
    
    
    func configureNavigation()
    {
        view.backgroundColor                        = .systemBackground
        title                                       = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(resumeAnimation), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    @objc func resumeAnimation()
    {
        UIImageView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.logoImageView.transform                            = CGAffineTransform(translationX: 0, y: -770)
        }) { (_) in
            UIImageView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
                self.logoImageView.transform                        = self.logoImageView.transform.translatedBy(x: 0, y: 40)
            }
        }
    }
    
    
    func addSubviews() { view.addSubviews(logoImageView, publisherNameTextField, callToActionButton) }
    
    
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
    
    
    func configureTextField()
    {
        let paddingView: UIView                 = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
        publisherNameTextField.delegate         = self
        publisherNameTextField.placeholder      = PlaceHolderKeys.searchPlaceHolder
        publisherNameTextField.leftView         = paddingView
        publisherNameTextField.rightView        = paddingView
        publisherNameTextField.leftViewMode     = .always
        publisherNameTextField.rightViewMode    = .always
        
        NSLayoutConstraint.activate([
            //48
            publisherNameTextField.topAnchor.constraint(equalTo: callToActionButton.topAnchor, constant: -75),
            publisherNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            publisherNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            publisherNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureCallToActionButton() {
        callToActionButton.backgroundColor  = .blue
        callToActionButton.setTitle("GO", for: .normal)
        callToActionButton.addTarget(self, action: #selector(pushAllOrFilteredPublishersVC), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func pushAllOrFilteredPublishersVC() {
        view.endEditing(true)
        UIImageView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.logoImageView.transform                        = self.logoImageView.transform.translatedBy(x: 0, y: -900)
        }, completion: { (_) in
            print("animation done")
            self.isPublisherEntered ? self.pushFilteredPublishersVC() : self.pushAllPublishersVC()
        })
    }
    
    
    func pushFilteredPublishersVC() {
        publisherNameTextField.resignFirstResponder()
        let publisherName           = publisherNameTextField.text!
        Task { try await APICaller.shared.getFilteredPublishers(withName: publisherName, page: 0) }
        
        let filteredPublishersVC    = FilteredPublishersVC(withName: publisherName)
        navigationController?.pushViewController(filteredPublishersVC, animated: true)
    }
    
    
    func pushAllPublishersVC() {
        publisherNameTextField.resignFirstResponder()
        let allPublishersVC = AllPublishersVC()
        navigationController?.pushViewController(allPublishersVC, animated: true)
    }
}


extension SearchVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        UIImageView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.logoImageView.transform                        = self.logoImageView.transform.translatedBy(x: 0, y: -900)
        }, completion: { (_) in
            print("animation done")
            self.isPublisherEntered ? self.pushFilteredPublishersVC() : self.pushAllPublishersVC()
        })
        return true
    }
}




