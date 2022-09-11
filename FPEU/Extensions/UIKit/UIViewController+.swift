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
        
        if (topMostViewController() is LoginViewController) {
            return
        }
        
        let vc: LoginViewController = UIStoryboard.authStoryboard.instantiateViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension UIViewController {
    static func topMostViewController() -> UIViewController? {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return keyWindow?.rootViewController?.topMostViewController()
        }
        
        return UIApplication.shared.keyWindow?.rootViewController?.topMostViewController()
    }
    
    func topMostViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topMostViewController()
        }
        else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.topMostViewController()
            }
            return tabBarController.topMostViewController()
        }
            
        else if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        
        else {
            return self
        }
    }
}
