//
//  UIView+.swift
//  FPEU
//
//  Created by son on 07/08/2022.
//

import Foundation
import UIKit

public extension UIView {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: Self.self))
    }

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIView {
    public class func fromNib<T: UIView>() -> T {
        let name = String(describing: Self.self);
        guard let nib = Bundle(for: Self.self).loadNibNamed(
                name, owner: nil, options: nil)
        else {
            fatalError("Missing nib-file named: \(name)")
        }
        return nib.first as! T
    }
}

extension UIView {
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height:2)
    }
}
