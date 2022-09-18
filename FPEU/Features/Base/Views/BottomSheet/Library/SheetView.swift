//
//  SheetView.swift
//  CoreUIKit
//
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

class SheetView: UIView {

    weak var delegate: SheetViewDelegate?

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return delegate?.sheetPoint(inside: point, with: event) ?? true
    }
}

#endif // os(iOS) || os(tvOS) || os(watchOS)
