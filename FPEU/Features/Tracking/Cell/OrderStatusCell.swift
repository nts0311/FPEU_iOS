//
//  OrderStatusCell.swift
//  FPEU
//
//  Created by son on 13/10/2022.
//

import UIKit

class OrderStatusCell: UITableViewCell {
    
    @IBOutlet weak var orderConfirmedDescriptionLabel: UILabel!
    @IBOutlet weak var gettingFoodReadyDesLabel: UILabel!
    @IBOutlet weak var deliveringOrderLabel: UILabel!
    
    func setOrderStatus(orderStatus: OrderStatus) {
        switch orderStatus {
        case .searchingDriver:
            setStateRow1(isEnabled: true)
            setStateRow2(isEnabled: false)
            setStateRow3(isEnabled: false)
        case .preparing:
            setStateRow1(isEnabled: false)
            setStateRow2(isEnabled: true)
            setStateRow3(isEnabled: false)
        case .delivering:
            setStateRow1(isEnabled: false)
            setStateRow2(isEnabled: false)
            setStateRow3(isEnabled: true)
        default: ()
        }
    }
    
    private func setStateRow1(isEnabled: Bool) {
        orderConfirmedDescriptionLabel.isHidden = !isEnabled
    }
    
    private func setStateRow2(isEnabled: Bool) {
        gettingFoodReadyDesLabel.isHidden = !isEnabled
    }
    
    private func setStateRow3(isEnabled: Bool) {
        deliveringOrderLabel.isHidden = !isEnabled
    }
    
}
