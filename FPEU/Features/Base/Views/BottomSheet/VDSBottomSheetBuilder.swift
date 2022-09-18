//
//  BottomSheetBuilder.swift
//  CoreUIKit
//
//  Created by Chi Nguyen on 9/15/20.
//  Copyright © 2020 ViettelPay App Team. All rights reserved.
//
import UIKit


public
extension Notification.Name {
    static let bottomSheetClose = Notification.Name(rawValue: "bottomSheetClose")
    static let bottomSheetTwo = Notification.Name(rawValue: "bottomSheetTwo")
}

@objc extension NSNotification {
    public static let bottomSheetClose = Notification.Name.bottomSheetClose
    public static let bottomSheetTwo = Notification.Name.bottomSheetTwo
}

@objc public class VDSBottomSheetBuilder: NSObject {

    @objc
    public static func buildFor(controller: UIViewController,
                                fixedHeight: Float = 0.0,
                                isFullScreenAllowed: Bool = false,
                                isFullScreenFirst: Bool = false,
                                contentColor: UIColor = .white) -> VDSBottomSheetVC {
        var options = SheetOptions()
        options.useInlineMode = false
        options.shouldExtendBackground = false
        options.shrinkPresentingViewController = false
        var sizesSetting : [SheetSize] = []
        if isFullScreenFirst {
            if isFullScreenAllowed {
                sizesSetting.append(.fullscreen)
            }
            if fixedHeight != 0.0 {
                sizesSetting.append(.fixed(CGFloat(fixedHeight)))
            }
        } else {
            if fixedHeight != 0.0 {
                sizesSetting.append(.fixed(CGFloat(fixedHeight)))
            } else {
                sizesSetting.append(.intrinsic)
            }
            if isFullScreenAllowed {
                sizesSetting.append(.fullscreen)
            }
        }
        let sheet = VDSBottomSheetVC(controller: controller, sizes: sizesSetting, options: options)
        sheet.shouldDismiss = { vc in
            NotificationCenter.default.post(name: .bottomSheetClose, object: nil)
            return true
        }
        sheet.gripColor = Colors.tokenWhite.withAlphaComponent(Opacity.tokenOpacity50)
        sheet.gripSize = CGSize(width: Sizing.tokenSizing32, height: Sizing.tokenSizing04)
        sheet.minimumSpaceAbovePullBar = HelperFunction.heightSafeAreaTop()
        sheet.pullBarBackgroundColor = .clear
        sheet.cornerRadius = 16//BorderRadius.tokenBorderRadius16
        sheet.contentBackgroundColor = contentColor
        sheet.treatPullBarAsClear = true
        sheet.allowPullingPastMaxHeight = false
        sheet.hasBlurBackground = false // disable to use VDSOverlayView
        return sheet
    }
}
