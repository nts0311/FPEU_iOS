//
//  TransparentCell.swift
//  FPEU
//
//  Created by son on 17/09/2022.
//

import UIKit

class ProductInfoCell: UITableViewCell {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var product: MerchantProduct! {
        didSet { initData() }
    }
    
    
    private func initData() {
        productNameLabel.text = product.name
        priceLabel.text = product.price.safeString.formatAmount
        descriptionLabel.text = product.description
    }
}
