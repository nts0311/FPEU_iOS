//
//  VDSBottomSheetContentBaseVC.swift
//  CoreUIKit
//
//  Created by Chi Nguyen on 9/24/20.
//  Copyright © 2020 ViettelPay App Team. All rights reserved.
//
import UIKit

open class VDSBottomSheetContentBaseVC : UIViewController {
    public lazy var header: VDSBottomSheetHeader = {
        let header = VDSBottomSheetHeader()
        return header
    }()
    
    override public var prefersStatusBarHidden: Bool {
        return false
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    public func initHeader(data: VDSBottomSheetHeaderData) {
        header.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: header.getHeight())
        view.addSubview(header)
        header.delegate = self as? VDSBottomSheetHeaderDelegate
        header.data = data
    }
    
    public func getHeightOfHeader() -> CGFloat {
        return header.getHeight()
    }

    public func setHeaderView(_ isShow: Bool, _ title: String) {
        header.setTitleAndLeftMenu(isShow, title)
    }
}
