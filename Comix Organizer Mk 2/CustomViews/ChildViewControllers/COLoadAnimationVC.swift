//
//  COLoadAnimationVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/1/24.
//

import UIKit

class COLoadAnimationVC: UIViewController {
    
    // see note 8 in app delegate
    private let stackView: UIStackView = { loadingDot in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    
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
                //keyframe = "how do you want this animated? in this case, rise & fall 30 points"
                UIView.addKeyframe(withRelativeStartTime: jumpRelativeTime, relativeDuration: jumpRelativeDuration) {
                    circle.frame.origin.y -= 30
                }
                UIView.addKeyframe(withRelativeStartTime: fallRelativeTime, relativeDuration: jumpRelativeDuration) {
                    circle.frame.origin.y += 30
                }
            })
        }
    }
    
    
    func configureStackView() {
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
}

