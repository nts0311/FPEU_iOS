//
//  VDSBottomSheetHeader.swift
//  CoreUIKit
//
//  Created by Chi Nguyen on 9/14/20.
//  Copyright © 2020 ViettelPay App Team. All rights reserved.
//

import UIKit
//import CoreUtilsKit
public enum VDSBottomSheetHeaderType {
    case title
    case titleAndDivider
    case titleAndIcon
    case titleDividerAndIcon
    case titleDividerAndLink(linkType: VDSBottomSheetLinkType)
}

public enum VDSBottomSheetLinkType {
    case left
    case right
    case both
}
@objc
public protocol VDSBottomSheetHeaderDelegate: NSObjectProtocol {
    @objc
    optional func bottomSheetHeader(_ bottomSheetHeader: VDSBottomSheetHeader, leftAction sender: Any)
    @objc
    optional func bottomSheetHeader(_ bottomSheetHeader: VDSBottomSheetHeader, rightAction sender: Any)
}

@IBDesignable
open class VDSBottomSheetHeader : UIView {
    // MARK: Constant
    let bundle = Bundle(for: VDSBottomSheetHeader.self)
    
    private let alternativeActionButtonWidth = CGFloat(80)

    // MARK: Variable
    public var data : VDSBottomSheetHeaderData? {
        didSet {
            guard let data = data else {
                return
            }
            title = data.title
            type = data.type
            setLeftAction(text: data.leftText, image: data.leftImage)
            setRightAction(text: data.rightText, image: data.rightImage)
            if let attributedTextTitle = data.attributedTextTitle {
                setAttributedTextForTitle(attributedTextTitle)
            }
        }
    }
    
    public var type : VDSBottomSheetHeaderType? {
        didSet {
            setType()
        }
    }
    
    var verticalPadding = Sizing.tokenSizing16
    
    var horizontalPadding = Sizing.tokenSizing16 {
        didSet {
            stackViewLeftContraint.constant = verticalPadding
            stackViewRightConstraint.constant = verticalPadding
        }
    }
    
    public weak var delegate: VDSBottomSheetHeaderDelegate?
    
    // MARK: Outlet Variable
    @IBOutlet private var contentView: UIView!

    @IBOutlet private weak var leftActionButton: UIButton!
    
    @IBOutlet private weak var rightActionButton: UIButton!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var dividerView: UIView!
    
    // Vertical constraint
    @IBOutlet private weak var stackViewLeftContraint: NSLayoutConstraint!
    
    @IBOutlet private weak var stackViewRightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var leftActionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var leftActionWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var rightActionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var rightActionWidthConstraint: NSLayoutConstraint!
    
    // MARK: IBInspectable Variable
    @IBInspectable public var showDivider: Bool = false {
        didSet {
            dividerView.isHidden = !showDivider
        }
    }
    
    @IBInspectable public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var leftActionText: String? {
        didSet {
            leftActionButton.setTitle(leftActionText, for: .normal)
        }
    }
    
    @IBInspectable var leftActionImage: UIImage? {
        didSet {
            leftActionButton.setImage(leftActionImage, for: .normal)
        }
    }
    
    @IBInspectable var rightActionText: String? {
        didSet {
            rightActionButton.setTitle(rightActionText, for: .normal)
        }
    }
    
    @IBInspectable var rightActionImage: UIImage? {
        didSet {
            rightActionButton.setImage(rightActionImage, for: .normal)
        }
    }
    // MARK: View action
    @IBAction func actionLeftButton(_ sender: Any) {
        if let delegate = delegate {
            delegate.bottomSheetHeader?(self, leftAction: sender)
        }
    }
    
    @IBAction func actionRightButton(_ sender: Any) {
        if let delegate = delegate {
            delegate.bottomSheetHeader?(self, rightAction: sender)
        }
    }
    // MARK: Setter
    public func setLeftAction(text: String?, image:UIImage?) {
        leftActionText = text
        leftActionImage = image
    }
    
    public func setRightAction(text: String?, image:UIImage?) {
        rightActionText = text
        rightActionImage = image
    }
    
    public func setAttributedTextForTitle(_ attributedText: NSAttributedString) {
        titleLabel.attributedText = attributedText
    }
    // MARK: Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let podBundle = HelperFunction.getBundle(for: VDSBottomSheetHeader.self, bundleResource: "CoreUIKitBundle")

        bundle.loadNibNamed(String(describing:VDSBottomSheetHeader.self), owner: self, options: nil)
    
        addSubview(contentView)
        contentView.frame = self.bounds
        
        titleLabel.font = Typography.fontBold18
        titleLabel.textColor = Colors.tokenDark100
        
        leftActionButton.titleLabel?.font = Typography.fontRegular18
        leftActionButton.setTitleColor(Colors.tokenViettelPayRed100, for: .normal)
        
        rightActionButton.titleLabel?.font = Typography.fontBold18
        rightActionButton.setTitleColor(Colors.tokenViettelPayRed100, for: .normal)
        
        leftActionHeightConstraint.constant = Sizing.tokenSizing32
        rightActionHeightConstraint.constant = leftActionHeightConstraint.constant
        
        leftActionWidthConstraint.constant = alternativeActionButtonWidth
        rightActionWidthConstraint.constant = leftActionWidthConstraint.constant
    }
    
    // MARK: Helper
    public func getHeight() -> CGFloat {
        return leftActionHeightConstraint.constant + verticalPadding * 2
    }
    
    private func setType() {
        horizontalPadding = Sizing.tokenSizing16
        switch type {
        case .title:
            leftActionButton.isHidden = true
            rightActionButton.isHidden = true
            showDivider = false
            verticalPadding = Sizing.tokenSizing16
        case .titleAndDivider:
            showDivider = true
            leftActionButton.isHidden = true
            rightActionButton.isHidden = true
            verticalPadding = Sizing.tokenSizing16
        case .titleAndIcon:
            showDivider = false
            leftActionImage = VDSBottomSheetHeaderData.defaultLeftImage
            rightActionImage = VDSBottomSheetHeaderData.defaultRightImage
            leftActionText = nil
            rightActionText = nil
            verticalPadding = Sizing.tokenSizing08
            
            leftActionButton.isHidden = false
            rightActionButton.isHidden = false
            
            leftActionWidthConstraint.constant = leftActionHeightConstraint.constant
        case .titleDividerAndIcon:
            showDivider = true
            leftActionImage = VDSBottomSheetHeaderData.defaultLeftImage
            rightActionImage = VDSBottomSheetHeaderData.defaultRightImage
            leftActionText = nil
            rightActionText = nil
            verticalPadding = Sizing.tokenSizing08
            
            leftActionButton.isHidden = false
            rightActionButton.isHidden = false
            
            leftActionWidthConstraint.constant = leftActionHeightConstraint.constant
        case .titleDividerAndLink(let linkType):
            showDivider = true
            leftActionImage = nil
            rightActionImage = nil
            leftActionText =  "Huỷ"//CoreUIKitLocalization.cancel.localized
            rightActionText = "Xong" //CoreUIKitLocalization.done.localized
            verticalPadding = Sizing.tokenSizing16
            
            leftActionButton.isHidden = false
            rightActionButton.isHidden = false
            
            leftActionWidthConstraint.constant = alternativeActionButtonWidth   
        case .none:
            break
        }
        rightActionWidthConstraint.constant = leftActionWidthConstraint.constant
        // update view height
        contentView.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: contentView.frame.size.width, height: getHeight())
    }

    func setTitleAndLeftMenu(_ isShow: Bool, _ title: String) {
        leftActionButton.isEnabled = isShow
        let leftImage = isShow ? leftActionImage : UIImage()
        leftActionButton.setImage(leftImage, for: .normal)
        titleLabel.text = title
    }
}
