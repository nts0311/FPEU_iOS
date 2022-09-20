//
//  PaymentDetailCell.swift
//  FPEU
//
//  Created by son on 20/09/2022.
//

import UIKit


struct PaymentDetail {
    var price: Double
    var deliveryFee: Double
    var serviceFee: Double
    var discounts: Double
    
    var totalPayment: Double {
        get {
            return price + deliveryFee + serviceFee + discounts
        }
    }
}

class PaymentDetailCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var serviceFeeLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    
    
    var paymentDetail: PaymentDetail! {
        didSet { initData() }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.borderWidth = 1.0
        cardView.layer.borderColor = UIColor.systemGray5.cgColor
    }

    private func initData() {
        priceLabel.text = String(paymentDetail.price).formatAmount
        deliveryFeeLabel.text = String(paymentDetail.deliveryFee).formatAmount
        serviceFeeLabel.text = String(paymentDetail.serviceFee).formatAmount
        discountLabel.text = String(paymentDetail.discounts).formatAmount
        
        totalPaymentLabel.text = String(paymentDetail.totalPayment).formatAmount
    }
    
}
