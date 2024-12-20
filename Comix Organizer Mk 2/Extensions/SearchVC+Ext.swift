//
//  SearchVC+Ext.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/20/24.
//

import UIKit
extension SearchVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        animateHeroFlyOut()
        return true
    }
    
    
    // MARK: CONFIGURATION LOGIC
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
        searchTextField.text                             = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor                                    = .systemBackground
        title                                                   = "Search"
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
        #warning("use a calayer approach here too?")
        NotificationCenter.default.addObserver(self, selector: #selector(pauseAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeAnimation), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
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
        callToActionButton.addTarget(self, action: #selector(animateHeroFlyOut), for: .touchUpInside)
        
        
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
}
