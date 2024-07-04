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
    let callToActionButton      = UIButton(frame: .zero)
    
    var isPublisherEntered: Bool { return !publisherNameTextField.text!.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "ComixOrganizer"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubviews(logoImageView, publisherNameTextField, callToActionButton)
        
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        publisherNameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    #warning("add 'createDismissKeyboardTapGesture( )' & its extension after successful run")
    
    
    @objc func pushAllPublishersListVC() {
        guard isPublisherEntered else { return }
        
        publisherNameTextField.resignFirstResponder()
        
        let publisherListVC = AllPublishersVC(selectedPublisher: publisherNameTextField.text!)
        navigationController?.pushViewController(publisherListVC, animated: true)
    }
    
    
    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.coLogo
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func configureTextField() {
        publisherNameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            publisherNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            publisherNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            publisherNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            publisherNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureCallToActionButton() {
        let selector: Selector              = isPublisherEntered ? #selector(pushSelectedPublisherTitlesVC) : #selector(pushAllPublishersVC)
        
        callToActionButton.backgroundColor  = .blue
        callToActionButton.setTitle("GO", for: .normal)
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        callToActionButton.addTarget(self, action: selector, for: .touchUpInside)

        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func pushSelectedPublisherTitlesVC() {
        // display alert 'about to be taken to 'Marvel' titles'
        // need to find a way to get publisherdetailsURL from typed name > API call
        var publisherName = publisherNameTextField.text!
        var publisherDetailsURL = ""
        
        Task { try await APICaller.shared.getPublisherTitles(withPublisherDetailsURL: publisherDetailsURL) }
        // add logic that says: if it comes back nil, display an alert || empty state view
        
        let selectedPublisherTitlesVC = SelectedPublisherTitlesVC(withPublisherName: publisherName, andPublisherDetailsURL: publisherDetailsURL)
        navigationController?.pushViewController(selectedPublisherTitlesVC, animated: true)
    }
    
    
    @objc func pushAllPublishersVC() {
        // display alert 'about to be taken to all publishers. to see titles from them, simply select.'
        let allPublishersVC = AllPublishersVC()
        navigationController?.pushViewController(allPublishersVC, animated: true)
    }
}


extension SearchVC: UITextFieldDelegate {
    // set up alert presentation / dismissal then handle the below
    // if isPublisherEntered is false...
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isPublisherEntered ? pushSelectedPublisherTitlesVC() : pushAllPublishersVC()
        return true
    }
    
    // if isPublisherEntered is true...
}



//extension SearchVC: PopUpWindowChildVCDelegate {
//    func presentTitlesViewController() {
//        let selectedPublisherTitlesVC                           = SelectedPublisherTitlesVC()
//
//        selectedPublisherTitlesVC.selectedPublisherName         = selectedPublisherName
//        selectedPublisherTitlesVC.selectedPublisherDetailsURL   = selectedPublisherDetailsURL
//
//        self.navigationController?.pushViewController(selectedPublisherTitlesVC, animated: true)
//    }
//}
