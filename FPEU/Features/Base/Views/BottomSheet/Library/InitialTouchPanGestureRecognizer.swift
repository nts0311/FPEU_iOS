//
//  InitialTouchPanGestureRecognizer.swift
//  CoreUIKit
//
//
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIGestureRecognizerSubclass

class InitialTouchPanGestureRecognizer: UIPanGestureRecognizer {
    var initialTouchLocation: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first?.location(in: view)
    }
}
#endif
