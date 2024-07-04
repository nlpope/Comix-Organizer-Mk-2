//
//  PopUpWindowChildVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/19/24.
//

import UIKit

protocol PopUpWindowChildVCDelegate {
    func presentTitlesViewController()
}

class PopUpWindowChildVC: UIViewController {
    
    var delegate: PopUpWindowChildVCDelegate?
    private let popUpWindowView = COPopUpWindowView()
    public var selectedPublisherName = ""
    public var selectedPublisherDetailsURL = ""
    
    #warning("rework this init after setting up just a one button popup to appear: text should always = 'you're about to see all publishers since you haven't specified one in the search field' ")
    init(title: String, text: String, buttonOneText: String, buttonTwoText: String, selectedPublisherName: String, selectedPublisherDetailsURL: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        popUpWindowView.popupTitle.text = title
        popUpWindowView.popupText.text = text
        popUpWindowView.popupButtonOne.setTitle(buttonOneText, for: .normal)
        popUpWindowView.popUpButtonTwo.setTitle(buttonTwoText, for: .normal)
        
        self.selectedPublisherName = selectedPublisherName
        self.selectedPublisherDetailsURL = selectedPublisherDetailsURL
        
        popUpWindowView.popupButtonOne.addTarget(self, action: #selector(goToTitles), for: .touchUpInside)
       
        
        view = popUpWindowView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goToTitles() {
        dismissView()
        delegate?.presentTitlesViewController()
    }

    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}



//MARK: QUESTIONS
/**
 > @objc func and how it works w ...addTarget(self, action: #selector()...)
 
 > review MVC architecture more in depth (helps w view & UIVC relationship)
 
 > review the role of view controllers: https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/index.html#//apple_ref/doc/uid/TP40007457
 >> then read an updated version elsewhere (above is an archived version)
 
 > review core app design: https://developer.apple.com/library/archive/documentation/General/Conceptual/MOSXAppProgrammingGuide/CoreAppDesign/CoreAppDesign.html
 */

//MARK: CREDITS & SOURCES
/**
 > John Codeos
 >> https://johncodeos.com/how-to-create-a-popup-window-in-ios-using-swift/
 
 > BJ Homer
 >> https://stackoverflow.com/questions/1151422/uiview-vs-uiviewcontroller
 */

