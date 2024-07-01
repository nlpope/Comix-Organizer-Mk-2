//
//  PopUpWindowView.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/19/24.
//

import UIKit
// see note _ in app delegate >
// delegates step 1. the protocol - next one here, up top
// "hmmmm this popupVC (manager) needs a delegate to talk to"
protocol PopUpWindowChildVCDelegate {
    func presentTitlesViewController()
}
//MARK: POP UP WINDOW VIEW CONTROLLER
//initializes data in PopUpWindowView
//cannot display anything, only decide WHAT gets displayed
//... to then send it off to the UIView (above) for set up
//closes/dismisses the window
//THE BEHAVIOR
class PopUpWindowChildVC: UIViewController {
    //delegates step 2. the delegate (to be defined in the delegate - allpubVC) - next one here, in goToTitles
    //"Okay! I can set up a delegate using the protocol type you just created so me and my 'employee' can communicate"
    var delegate: PopUpWindowChildVCDelegate?
    private let popUpWindowView = COPopUpWindowView()
    public var selectedPublisherName = ""
    public var selectedPublisherDetailsURL = ""
    
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
        //delegates step 3. the delegate execution - next one in allpubVC @ bottom
        //"Now that the delegate (of type protocol) is set up (but not yet defined), I'll be the one to tell said delegate to do something with the func it's required to have. REFER TO ME IN THIS VC'S INIT > VIEW.BUTTONNAME.ADDTARGET(..#SELECTOR) METHOD"
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

