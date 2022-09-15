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
    
    
    var product: MerchantProduct! {
        didSet { initData() }
    }
    
    private func initData() {
        labelProductName.text = product.name
        let price = String(Int(product.price ?? 0.0)).formatAmount ?? ""
        labelProductPrice.text = "\(price)"
        imageProduct.sd_setImage(with: product.imageUrl.url, placeholderImage: UIImage(named: "dish"))
        
        
    }
}
