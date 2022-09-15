//
//  MerchantItemTableViewCell.swift
//  FPEU
//
//  Created by son on 11/09/2022.
//

import UIKit
import SDWebImage

class MerchantItemTableViewCell: UITableViewCell {

    @IBOutlet private weak var merchantImageView: UIImageView!
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var subTitle: UILabel!
    @IBOutlet private weak var labelStar: UILabel!
    @IBOutlet private weak var labelOrderNum: UILabel!
    @IBOutlet private weak var labelDistance: UILabel!
    
    var merchantItem: MerchantItem! {
        didSet { initData() }
    }

    private func initData() {
        merchantImageView.sd_setImage(with: URL(string: merchantItem.imageUrl ?? ""), placeholderImage: UIImage(named: "placeholder_restaurant"))
        labelName.text = merchantItem.name ?? ""
        subTitle.text = merchantItem.subTitle
        
        if let starNum = merchantItem.numStar, let numOrder = merchantItem.numOrder {
            labelStar.text = "\(starNum)"
            labelOrderNum.text = "(\(numOrder))"
        } else {
            labelStar.text = "--"
            labelOrderNum.text = "(--)"
        }
        
        if let distance = merchantItem.distance {
            labelDistance.text = distance.prettyDistance
        } else {
            labelDistance.text = "--"
        }
    }
    
}
