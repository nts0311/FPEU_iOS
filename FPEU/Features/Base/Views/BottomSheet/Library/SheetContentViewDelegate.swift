//
//  SheetContentViewDelegate.swift
//  CoreUIKit
//
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

protocol SheetContentViewDelegate: class {
    func preferredHeightChanged(oldHeight: CGFloat, newSize: CGFloat)
    func pullBarTapped()
}

#endif // os(iOS) || os(tvOS) || os(watchOS)
