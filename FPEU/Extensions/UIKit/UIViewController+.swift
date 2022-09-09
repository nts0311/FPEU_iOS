//
//  UIViewController+.swift
//  FPEU
//
//  Created by son on 07/08/2022.
//

import Foundation
import UIKit

extension UIViewController {
    static func initFromNib() -> Self {
        func initFromNib<T: UIViewController>(_ viewType: T.Type) -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return initFromNib(self)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController {
    func showLoginScreen() {
        let vc: LoginViewController = UIStoryboard.authStoryboard.instantiateViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
