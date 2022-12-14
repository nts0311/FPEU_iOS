//
//  DeliveringDetailCell.swift
//  FPEU
//
//  Created by son on 13/10/2022.
//

import UIKit

class DeliveringDetailCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var driverInfoView: UIStackView!
    @IBOutlet weak var driverInfoDivider: UIView!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverPlateLabel: UILabel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var receivingAddressLabel: UILabel!
    
    var orderInfo: OrderInfo! {
        didSet { initData() }
    }
    
    var orderTrackingTapped: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.borderWidth = 1.0
        cardView.layer.borderColor = UIColor.systemGray5.cgColor
    }

    func initData() {
        if let driverName = orderInfo.driverInfo?.name, let driverPlate = orderInfo.driverInfo?.driverPlate {
            driverInfoView.isHidden = false
            driverInfoDivider.isHidden = false
            driverNameLabel.text = driverName
            driverPlateLabel.text = driverPlate
        } else {
            driverInfoView.isHidden = true
            driverInfoDivider.isHidden = true
        }
        
        merchantNameLabel.text = orderInfo.merchantName
        receivingAddressLabel.text = orderInfo.toAddress.toString()
    }
    
    @IBAction func buttonCallDriverTapped(_ sender: Any) {
        guard let driverPhone = orderInfo.driverInfo?.phone else {
            return
        }
        
    }
    
    @IBAction func driverTrackingTapped(_ sender: Any) {
        orderTrackingTapped()
    }
    
    
}
