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
    
    private func initData() {
        AddressLabel.text = address.detail
    }
    
    private func setEstimatedTime(time: Int) {
        estimateTimeLabel.text = "Dự kiên giao trong \(time) phút"
    }
    
    @IBAction func btnChangeAddressTapped(_ sender: Any) {
        onChangeAddressTapped?()
    }
    
}
