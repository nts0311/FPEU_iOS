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
