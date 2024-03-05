//
//  LoadAnimationViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 3/5/24.
//

import Foundation
import UIKit

class LoadAnimationViewController: UIViewController {
    private let stackView: UIStackView = {
        return $0
        //$0 = auto arg that generates as alt. shorthand arg in lieu of (let's say) ...{ loadingDot in or ...{ _ in
    }(UIStackView())
}

//https://stackoverflow.com/questions/62208949/how-to-make-loading-animation-in-ios-swift
