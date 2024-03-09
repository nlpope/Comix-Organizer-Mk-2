//
//  LoadAnimationViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 3/5/24.
//

//ADD / DISPLAY USING VIEWWILLAPPEAR() METHOD?
//dismissView() will get rid of this VC like it gets rid of the PopUpWindowVC > goToTitles/Characters() methods
import Foundation
import UIKit

private class LoadAnimationView: UIView {
    
}

class LoadAnimationViewController: UIViewController {
    //delegation #2
    var delegate: LoadAnimationDelegate?
    private let loadAnimationView = LoadAnimationView()
    //add a view above this & treat it like a larger version of the popupwindowView/VC relationship, but w/out the buttons?
    private let stackView: UIStackView = {loadingDot in
        loadingDot.distribution = .fill
        loadingDot.axis = .horizontal
        loadingDot.alignment = .center
        loadingDot.spacing = 10
        return loadingDot
        //if loadDot wasn't here, I'd use $0 = auto arg that generates as alt. shorthand arg in lieu of (let's say) ...{ loadingDot in or ...{ _ in
    }(UIStackView())
    
    private let circleA = UIView()
    private let circleB = UIView()
    private let circleC = UIView()
    private lazy var circles = [circleA, circleB, circleC]
    
    func animate() {
        let jumpDuration: Double = 0.30
        let delayDuration: Double = 1.25
        let totalDuration: Double = delayDuration + jumpDuration*2
        
        let jumpRelativeDuration: Double = jumpDuration / totalDuration
        let jumpRelativeTime: Double = delayDuration / totalDuration
        let fallRelativeTime: Double = (delayDuration + jumpDuration) / totalDuration
        
        //below: the .enumerated() method gives you access to the "index" var set up just before
        for (index, circle) in circles.enumerated() {
            let delay = jumpDuration*2 * TimeInterval(index) / TimeInterval(circles.count)
            UIView.animateKeyframes(withDuration: totalDuration, delay: delay, options: [.repeat], animations: {
                //keyframe = "how do you want this animated? in this case, rise & fall 30 points
                UIView.addKeyframe(withRelativeStartTime: jumpRelativeTime, relativeDuration: jumpRelativeDuration) {
                    circle.frame.origin.y -= 30
                }
                UIView.addKeyframe(withRelativeStartTime: fallRelativeTime, relativeDuration: jumpRelativeDuration) {
                    circle.frame.origin.y += 30
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circles.forEach {
            $0.layer.cornerRadius = 20/2
            $0.layer.masksToBounds = true
            $0.backgroundColor = .systemBlue
            stackView.addArrangedSubview($0)
            $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    //delegation #3 (confused - what do i want it to do?)
    @objc func dismissAndGoToSelectedVC() {
        dismissView()
    }
    
    @objc func dismissView() {
        print("dismissing load animation")
        self.dismiss(animated: true, completion: nil)
    }
}

//delegation #1
protocol LoadAnimationDelegate {
    func presentLoadingAnimationViewController()
    func dismissLoadingAnimationViewController()
}

/**
 QUESTIONS & REFERENCE CREDITS
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 QUESTIONS:
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 REFERENCE CREDITS:
 > Overall Loading Animation layout
 >> https://stackoverflow.com/questions/62208949/how-to-make-loading-animation-in-ios-swift
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------

 */

