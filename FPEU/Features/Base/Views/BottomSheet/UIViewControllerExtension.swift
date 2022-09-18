//
//  UIViewControllerExtension.swift
//  CoreUIKit
//
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

public extension UIViewController {// swiftlint:disable all
    /// The sheet view controller presenting the current view controller heiarchy (if any)
    var sheetViewController: VDSBottomSheetVC? {
        var parent = self.parent
        while let currentParent = parent {
            if let sheetViewController = currentParent as? VDSBottomSheetVC {
                return sheetViewController
            } else {
                parent = currentParent.parent
            }
        }
        return nil
    }
}

#endif // os(iOS) || os(tvOS) || os(watchOS)
