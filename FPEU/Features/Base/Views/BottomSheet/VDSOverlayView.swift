//
//  VDSOverlayView.swift
//  CoreUIKit
//
//  Created by Le Tuan Hung on 9/25/20.
//  Copyright © 2020 ViettelPay App Team. All rights reserved.
//

import UIKit

public protocol VDSOverlayViewDelegate: NSObjectProtocol {
    func didTapOverlay(_ sender: UIGestureRecognizer)
}

@IBDesignable
public class VDSOverlayView: UIView {

    private var contentView: UIView?
    private var button: UIButton?
    
    public weak var delegate: VDSOverlayViewDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

extension VDSOverlayView {
    private func commonInit() {
        setupSize()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Colors.tokenBlack.withAlphaComponent(Opacity.tokenOpacity60)
        initTapGesture()
    }
    
    private func setupSize() {
        heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }
    
    private func initTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapOverlay(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func actionTapOverlay(_ sender: UITapGestureRecognizer) {
        delegate?.didTapOverlay(sender)
    }
}
