//
//  OrderedProductCell.swift
//  FPEU
//
//  Created by son on 19/09/2022.
//

import UIKit

class OrderedProductCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var itemNumView: ItemNumView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var productItem: ProductCartItem! {
        didSet { initData() }
    }
    
    var onNewValue: ((Int) -> Void)?
    
    private func initData() {
        nameLabel.text = productItem.product.name
        priceLabel.text = String(productItem.calculatePrice()).formatAmount
        optionsLabel.text = productItem.getOptionsAsString()
        productImage.sd_setImage(with: productItem.product.imageUrl.url, placeholderImage: UIImage(named: "dish"))
        
        itemNumView.num = productItem.num
        itemNumView.onNewValue = self.onNewValue
    }
    
}
