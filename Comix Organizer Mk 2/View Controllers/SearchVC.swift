//
//  SearchVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/28/24.
//

import UIKit

protocol SearchVCDelegate: AnyObject {
    func didRequestPublishers(for publisherName: String)
}

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
        callToActionButton.backgroundColor = .blue
        callToActionButton.setTitle("GO", for: .normal)
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        
        callToActionButton.addTarget(self, action: #selector(pushPublisherVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func pushPublisherVC() {
        let publisherVC = AllPublishersVC(selectedPublisher: <#String#>)
        navigationController?.pushViewController(publisherVC, animated: true)
    }
}


#warning("does not need to be a delegate if just pushing the publishersVC indescrim.")
extension SearchVC: PopUpWindowChildVCDelegate {
    func presentTitlesViewController() {
        let selectedPublisherTitlesVC                           = SelectedPublisherTitlesVC()
        
        selectedPublisherTitlesVC.selectedPublisherName         = selectedPublisherName
        selectedPublisherTitlesVC.selectedPublisherDetailsURL   = selectedPublisherDetailsURL
        
        self.navigationController?.pushViewController(selectedPublisherTitlesVC, animated: true)
    }
}


//extension COSearchVC: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        pushPublisherVC()
//        return true
//    }
//}
