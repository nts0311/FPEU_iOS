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
    @IBOutlet weak var imageRow1: UIImageView!
    @IBOutlet weak var imageRow2: UIImageView!
    @IBOutlet weak var imageRow3: UIImageView!
    
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
        imageRow1.image = UIImage(named: isEnabled ? "ic_finding_driver" : "ic_finding_driver_gray")
    }
    
    private func setStateRow2(isEnabled: Bool) {
        gettingFoodReadyDesLabel.isHidden = !isEnabled
        imageRow2.image = UIImage(named: isEnabled ? "ic_preparing_order" : "ic_preparing_order_gray")
    }
    
    private func setStateRow3(isEnabled: Bool) {
        deliveringOrderLabel.isHidden = !isEnabled
        imageRow3.image = UIImage(named: isEnabled ? "ic_delivering_order" : "ic_delivering_order_gray")
    }
    
}
