//
//  BottomSheetHeaderData.swift
//  CoreUIKit
//
//  Created by Chi Nguyen on 9/24/20.
//  Copyright © 2020 ViettelPay App Team. All rights reserved.
//
import UIKit
//import CoreUtilsKit

public struct VDSBottomSheetHeaderData {
    public var type = VDSBottomSheetHeaderType.title
    public var title = ""
    public var attributedTextTitle : NSAttributedString?
    public var leftImage : UIImage?
    public var leftText = ""
    public var rightImage : UIImage?
    public var rightText = ""
    
    public static let defaultLeftImage = HelperFunction.getImage(named: "ic_left_arrow_long_32_dark100",
                                                                 in: Bundle( for:VDSBottomSheetHeader.self))?.withRenderingMode(.alwaysOriginal)
    public static let defaultRightImage = HelperFunction.getImage(named: "ic_right_arrow_long_32_dark100",
                                                                  in: Bundle(for: VDSBottomSheetHeader.self))?.withRenderingMode(.alwaysOriginal)
    
    public init() {
        
    }
}
