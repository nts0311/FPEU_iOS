//
//  OrderdItemsCell.swift
//  FPEU
//
//  Created by son on 13/10/2022.
//

import UIKit

class OrderdItemsCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.borderWidth = 1.0
        cardView.layer.borderColor = UIColor.systemGray5.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
