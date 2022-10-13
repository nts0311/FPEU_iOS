//
//  CheckInAddressCell.swift
//  FPEU
//
//  Created by son on 20/09/2022.
//

import UIKit

class CheckInAddressCell: UITableViewCell {

    @IBOutlet weak var estimateTimeLabel: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    
    var onChangeAddressTapped: (() -> Void)?
    
    var address: FPAddress! {
        didSet { initData() }
    }
    
    var estimatedRouteInfo: OrderEstimatedRouteInfo? {
        didSet { setEstimatedTime() }
    }
    
    private func initData() {
        AddressLabel.text = address.detail
    }
    
    private func setEstimatedTime() {
        guard let estimatedRouteInfo = estimatedRouteInfo else {
            estimateTimeLabel.isHidden = true
            return
        }

        let mins = Double(Double(estimatedRouteInfo.durationInSec) / 60.0).rounded(.up)
        estimateTimeLabel.isHidden = false
        estimateTimeLabel.text = "Dự kiên giao trong \(Int(mins)) phút (\(estimatedRouteInfo.distanceReadable))."
    }
    
    @IBAction func btnChangeAddressTapped(_ sender: Any) {
        onChangeAddressTapped?()
    }
    
}
