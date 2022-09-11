//
//  CCPortalTopicCollectionViewCell.swift
//  ViettelPay
//
//  Created by Ngô Huân on 26/05/2022.
//  Copyright © 2022 Viettel. All rights reserved.
//

import UIKit
import SDWebImage

class ProductCategoryCell : UICollectionViewCell {
    
    @IBOutlet weak var topicImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var category: ProductCategory! {
        didSet {
            initData()
        }
    }
    
    func initData() {
        nameLabel.text = category.name
        topicImage.sd_setImage(with: URL(string: category.imageUrl ?? ""), placeholderImage: UIImage(named: "dish"))
    }
    
}
