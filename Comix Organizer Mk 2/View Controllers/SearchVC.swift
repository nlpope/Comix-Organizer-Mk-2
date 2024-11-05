//
//  SearchVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/28/24.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView           = UIImageView()
    let publisherNameTextField  = COTextField()
    let callToActionButton      = COButton(backgroundColor: .blue, title: "Get Publishers")
    var isPublisherEntered: Bool { return !publisherNameTextField.text!.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        setupKeyboardHiding()
        addKeyboardDismissOnTap()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        publisherNameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func setUpView() {
        view.backgroundColor                        = .systemBackground
        title = "ComixOrganizer"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubviews(logoImageView, publisherNameTextField, callToActionButton)
    }
    
    
    @objc func pushAllPublishersListVC() {
        guard !isPublisherEntered else { return }
        
        publisherNameTextField.resignFirstResponder()
        
        let allPublisherListVC = AllPublishersVC()
        navigationController?.pushViewController(allPublisherListVC, animated: true)
    }
    
    
    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image             = Images.coLogo
        logoImageView.layer.zPosition   = -1
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 350),
            logoImageView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    
    func configureTextField() {
        let paddingView: UIView                 = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
        publisherNameTextField.delegate         = self
        publisherNameTextField.placeholder      = PlaceHolders.searchPlaceHolder
        publisherNameTextField.leftView         = paddingView
        publisherNameTextField.rightView        = paddingView
        publisherNameTextField.leftViewMode     = .always
        publisherNameTextField.rightViewMode    = .always
        
        NSLayoutConstraint.activate([
            //48
            publisherNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 75),
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
    
    
    @objc func pushAllOrFilteredPublishersVC() { isPublisherEntered ? pushFilteredPublishersVC() : pushAllPublishersVC() }
    
    func pushFilteredPublishersVC() {
        let publisherName = publisherNameTextField.text!
        Task { try await APICaller.shared.getFilteredPublishers(withName: publisherName, page: 0) }
        
        let filteredPublishersVC = FilteredPublishersVC(withName: publisherName)
        navigationController?.pushViewController(filteredPublishersVC, animated: true)
    }
    
    
    func pushAllPublishersVC() {
        let allPublishersVC = AllPublishersVC()
        navigationController?.pushViewController(allPublishersVC, animated: true)
    }
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isPublisherEntered ? pushFilteredPublishersVC() : pushAllPublishersVC()
        return true
    }
}




