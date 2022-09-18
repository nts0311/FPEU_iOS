//
//  ItemNumView.swift
//  FPEU
//
//  Created by son on 18/09/2022.
//

import UIKit

@IBDesignable
class ItemNumView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var descBtn: UIButton!
    @IBOutlet private weak var incBtn: UIButton!
    @IBOutlet weak var labelNum: UILabel!
    
    @IBInspectable
    var num: Int = 0 {
        didSet { onSetNum() }
    }
    
    @IBInspectable
    var minNum: Int = 0 {
        didSet { onSetNum() }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 36)
    }
    
    var onNewValue: ((Int) -> Void)?
    
    override func prepareForInterfaceBuilder() {
        invalidateIntrinsicContentSize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        
        Bundle(for: ItemNumView.self).loadNibNamed(String(describing: ItemNumView.self), owner: self, options: nil)
        
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
    
    @IBAction func btnTapped(_ sender: UIButton) {
        if (sender == incBtn) {
            num += 1
        } else {
            num -= 1
        }
        valiateDescButton()
        updateLabel()
        onNewValue?(num)
    }
    
    private func onSetNum() {
        updateLabel()
        valiateDescButton()
    }
    
    private func valiateDescButton() {
        
        let isValidNum = num > minNum
        
        descBtn.isEnabled = isValidNum
        descBtn.backgroundColor = isValidNum ? UIColor.mainColor : UIColor.lightGray
    }
    
    private func updateLabel() {
        labelNum.text = "\(num)"
    }
}
