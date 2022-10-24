//
//  TableViewCell.swift
//  FPEU
//
//  Created by son on 24/10/2022.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDetailLocation: UILabel!
    
    
    var address: FPAddress! {
        didSet { initData() }
    }

    private func initData() {
        self.labelName.text = address.name ?? ""
        self.labelDetailLocation.text = address.toString()
    }
    
}
