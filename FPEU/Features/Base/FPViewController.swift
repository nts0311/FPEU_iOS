//
//  FPViewController.swift
//  FPEU
//
//  Created by son on 06/09/2022.
//

import Foundation
import UIKit
import RxSwift

class FPViewController: UIViewController {
    public let disposeBag = DisposeBag()
    
    public func showAlertDialog(
        title: String,
        message: String,
        firstActionTitle: String = "OK",
        secondActionTitle: String? = nil,
        firstAction: (() -> Void)? = nil,
        secondAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: firstActionTitle, style: .default) { (sender: UIAlertAction) -> Void in
            firstAction?()
            alert.dismiss(animated: true)
        }
        alert.addAction(alertAction)

        if let secondActionTitle = secondActionTitle {
            let secondAlertAction = UIAlertAction(title: secondActionTitle, style: .default) { (sender: UIAlertAction) -> Void in
                secondAction?()
                alert.dismiss(animated: true)
            }
            
            alert.addAction(secondAlertAction)
        }
        
        present(alert, animated: true)
    }
    
}
