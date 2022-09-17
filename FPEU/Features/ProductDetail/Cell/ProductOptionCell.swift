//
//  ProductOptionCell.swift
//  FPEU
//
//  Created by son on 17/09/2022.
//

import UIKit

class ProductOptionCell: UITableViewCell {

    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    
    var option: ProductAttributeOption! {
        didSet { initData() }
    }
    
    func initData() {
        labelName.text = option.name
        labelPrice.text = option.price.safeString.formatAmount
    }
    
    func setChecked(_ isChecked: Bool) {
        checkMarkImage.isHidden = !isChecked
    }
}
