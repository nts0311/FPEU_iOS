//
//  SheetViewDelegate.swift
//  CoreUIKit
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

protocol SheetViewDelegate: class {
    func sheetPoint(inside point: CGPoint, with event: UIEvent?) -> Bool
}

#endif // os(iOS) || os(tvOS) || os(watchOS)
