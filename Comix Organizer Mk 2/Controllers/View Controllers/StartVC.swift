//
//  StartVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 6/28/24.
//

import UIKit

class StartVC: UIViewController {
    
    let callToActionButton = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "ComixOrganizer"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(callToActionButton)
        configureCallToActionButton()
    }
    
    
    func configureCallToActionButton() {
        callToActionButton.backgroundColor = .blue
        callToActionButton.setTitle("get publishers", for: .normal)
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
        let publisherVC = AllPublishersViewController()
        navigationController?.pushViewController(publisherVC, animated: true)
    }
}


//extension COSearchVC: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        pushPublisherVC()
//        return true
//    }
//}
