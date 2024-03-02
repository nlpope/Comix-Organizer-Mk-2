//
//  PopUpWindowView.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/19/24.
//


//MARK: CONTAINS BOTH THE VIEW & VIEW CONTROLLER
import Foundation
import UIKit
//MARK: POP UP WINDOW VIEW
//recognizes touches and gestures & notifies the UIVC
//displays what you actually see
//sets the constraints (...what you actually see)
//configuration instructions sent by the UIVC
//THE LOOK
private class PopUpWindowView: UIView {
    
    let popupView = UIView(frame: CGRect.zero)
    let popupTitle = UILabel(frame: CGRect.zero)
    let popupText = UILabel(frame: CGRect.zero)
    let popupButtonOne = UIButton(frame: CGRect.zero)
    let popUpButtonTwo = UIButton(frame: CGRect.zero)
    let selectedPublisherName = ""
    let selectedPublisherDetailsURL = ""
    
    let BorderWidth: CGFloat = 2.0
    
    
    init() {
        super.init(frame: CGRect.zero)
        //semi-transparent background
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        //popup background
        popupView.backgroundColor = UIColor.black
        popupView.layer.borderWidth = BorderWidth
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = UIColor.white.cgColor
        
        //popup title
        popupTitle.textColor = UIColor.white
        popupTitle.backgroundColor = UIColor.black
        popupTitle.adjustsFontSizeToFitWidth = true
        popupTitle.clipsToBounds = true
        popupTitle.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupTitle.numberOfLines = 1
        popupTitle.textAlignment = .center
        
        //popup text
        popupText.textColor = UIColor.white
        popupText.numberOfLines = 0
        popupText.textAlignment = .center
        
        //popup button one
        popupButtonOne.setTitleColor(UIColor.white, for: .normal)
        popupButtonOne.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupButtonOne.backgroundColor = UIColor.yellow
        popupButtonOne.sendActions(for: .touchUpInside)
        
        //popup button two
        popUpButtonTwo.setTitleColor(UIColor.white, for: .normal)
        popUpButtonTwo.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popUpButtonTwo.backgroundColor = UIColor.yellow
        popUpButtonTwo.sendActions(for: .touchUpInside)
        
        popupView.addSubview(popupTitle)
        popupView.addSubview(popupText)
        popupView.addSubview(popupButtonOne)
        popupView.addSubview(popUpButtonTwo)
        
        // Add the popupView(box) in the PopUpWindowView (semi-transparent background)
        addSubview(popupView)
        
        
        // PopupView constraints
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: 293),
            popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        // PopupTitle constraints
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupTitle.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            popupTitle.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupTitle.topAnchor.constraint(equalTo: popupView.topAnchor, constant: BorderWidth),
            popupTitle.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        //MARK: POTENTIAL PROBLEM CHILD FOR BUTTON TWO
        // PopupText constraints
        popupText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupText.heightAnchor.constraint(greaterThanOrEqualToConstant: 67),
            popupText.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: 8),
            popupText.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 15),
            popupText.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15),
            popupText.bottomAnchor.constraint(equalTo: popupButtonOne.topAnchor, constant: -8)
        ])
        
        
        // popupButtonOne constraints
        popupButtonOne.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupButtonOne.heightAnchor.constraint(equalToConstant: 44),
            popupButtonOne.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            popupButtonOne.widthAnchor.constraint(equalTo: popupView.widthAnchor, multiplier: 0.5),
            popupButtonOne.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -BorderWidth)
        ])
        popupButtonOne.layer.borderWidth = 0.8

        
        // popupButtonTwo constraints
        popUpButtonTwo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popUpButtonTwo.heightAnchor.constraint(equalToConstant: 44),
            popUpButtonTwo.leadingAnchor.constraint(equalTo: popupButtonOne.trailingAnchor),
            popUpButtonTwo.trailingAnchor.constraint(equalTo: popupView.trailingAnchor),
            popUpButtonTwo.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -BorderWidth)
        ])
        popUpButtonTwo.layer.borderWidth = 0.8
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: POP UP WINDOW VIEW CONTROLLER
//initializes data in PopUpWindowView
//cannot display anything, only decide WHAT gets displayed
//... to then send it off to the UIView (above) for set up
//closes/dismisses the window
//THE BEHAVIOR
class PopUpWindowViewController: UIViewController {
    private let popUpWindowView = PopUpWindowView()
    public var selectedPublisherName = ""
    public var selectedPublisherDetailsURL = ""
//    var vcSelectedFromPopUp = ""
    
    
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
        popUpWindowView.popUpButtonTwo.addTarget(self, action: #selector(goToCharacters), for: .touchUpInside)
        
        view = popUpWindowView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //might not be necessary 
//    func topMostController() -> UIViewController? {
//        guard let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first, let rootViewController = window.rootViewController else {
//            return nil
//        }
//        
//        var topController = rootViewController
//        
//        while let newTopController = topController.presentedViewController {
//            topController = newTopController
//        }
//        
//        return topController
//    }
    
    @objc func goToTitles() {
        print("going to titles")
        let selectedPublisherTitlesVC = SelectedPublisherTitlesViewController()
        selectedPublisherTitlesVC.selectedPublisherName = self.selectedPublisherName
        selectedPublisherTitlesVC.selectedPublisherDetailsURL = self.selectedPublisherDetailsURL
        
//        self.navigationController?.pushViewController(selectedPublisherTitlesVC, animated: true)
        
        print("in goToTitles & about to dismiss view")
        dismissView()
    }
    
    @objc func goToCharacters() {
        print("going to characters")
        dismissView()
    }
    
    @objc func dismissView() {
        print("dismissing popup selector")
        self.dismiss(animated: true, completion: nil)
    }
}

protocol PopUpDelegate {
    func presentNewViewController()
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

