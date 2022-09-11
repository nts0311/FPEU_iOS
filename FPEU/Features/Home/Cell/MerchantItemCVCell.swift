//
//  MerchantItemCVCell.swift
//  FPEU
//
//  Created by son on 11/09/2022.
//

import UIKit
import SDWebImage

class MerchantItemCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelStar: UILabel!
    @IBOutlet weak var labelOrderNum: UILabel!
    @IBOutlet weak var statView: UIStackView!
    
    var merchantItem: MerchantItem! {
        didSet { initData() }
    }

    private func initData() {
        imageView.sd_setImage(with: URL(string: merchantItem.imageUrl ?? ""), placeholderImage: UIImage(named: "placeholder_restaurant"))
        labelName.text = merchantItem.name ?? ""
        
        if let starNum = merchantItem.numStar, let numOrder = merchantItem.numOrder {
            labelStar.text = "\(starNum)"
            labelOrderNum.text = "(\(numOrder))"
        } else {
            statView.isHidden = true
        }
        
        //self.labelStar.text = "4.3"
        //self.labelOrderNum.text = "(999+)"
    }
}
