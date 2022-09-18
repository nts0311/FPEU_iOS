//
//  ProductAttributeHeader.swift
//  FPEU
//
//  Created by son on 17/09/2022.
//

import UIKit

class ProductAttributeHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var labelRequired: UILabel!
    @IBOutlet weak var labelAttributeName: UILabel!
    
    var productAttribute: ProductAttribute! {
        didSet { initData() }
    }
    
    func initData() {
        labelAttributeName.text = productAttribute.name
        labelRequired.isHidden = !(productAttribute.required ?? false)
    }
    
    override func awakeFromNib() {
        contentView.backgroundColor = UIColor(hex: "F2F2F7")
    }
}
