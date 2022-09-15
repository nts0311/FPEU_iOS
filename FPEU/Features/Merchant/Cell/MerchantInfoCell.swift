//
//  MerchantInfoCell.swift
//  FPEU
//
//  Created by son on 13/09/2022.
//

import UIKit

class MerchantInfoCell: UITableViewCell {

    @IBOutlet private weak var labelMerchantName: UILabel!
    @IBOutlet private weak var labelDistance: UILabel!
    @IBOutlet private weak var labelAddress: UILabel!
    
    var merchantItem: MerchantItem! {
        didSet { initData() }
    }
    
    private func initData() {
        labelMerchantName.text = merchantItem.name
        
        labelAddress.text = merchantItem.address?.toString()
        
        if let distance = GPSUtils.calculateDistance(address1: UserRepo.shared.currentUserAddress, address2: merchantItem.address) {
            labelDistance.text = distance.prettyDistance
        } else {
            labelDistance.text = "--km"
        }
    }
    
}
