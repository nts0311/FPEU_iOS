//
//  UIStoryboard+.swift
//  FPEU
//
//  Created by son on 04/09/2022.
//

import Foundation
import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = instantiateViewController(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could find view controller: \(T.reuseIdentifier), in storyboard")
        }
        return viewController
    }
    
    static var authStoryboard: UIStoryboard {
        return UIStoryboard(name: "Auth", bundle: .main)
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: .main)
    }
}
