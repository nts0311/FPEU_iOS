//
//  OrderedItemCell.swift
//  FPEU
//
//  Created by son on 13/10/2022.
//

import UIKit

class OrderedItemCell: UITableViewCell {
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item: OrderedItem! {
        didSet { initData() }
    }

    func initData() {
        numLabel.text = "\(item.num)x"
        nameLabel.text = item.name
        descriptionLabel.text = item.getAttrsAsString()
    }
    
}
