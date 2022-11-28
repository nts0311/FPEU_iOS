//
//  ProductItemCell.swift
//  FPEU
//
//  Created by son on 14/09/2022.
//

import UIKit

class ProductItemCell: UITableViewCell {
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelProductPrice: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var notAvailableLabel: UILabel!
    
    
    var product: MerchantProduct! {
        didSet { initData() }
    }
    
    private func initData() {
        labelProductName.text = product.name
        let price = String(Int(product.price ?? 0.0)).formatAmount ?? ""
        labelProductPrice.text = "\(price)"
        imageProduct.sd_setImage(with: product.imageUrl.url, placeholderImage: UIImage(named: "dish"))
        
       
        contentView.alpha = product.isAvailable ? 1 : 0.5
        notAvailableLabel.isHidden = product.isAvailable
    }
}
