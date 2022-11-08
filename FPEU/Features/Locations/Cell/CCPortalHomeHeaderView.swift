//
//  CCPortalHomeHeaderView.swift
//  ViettelPay
//
//  Created by Ngô Huân on 20/05/2022.
//  Copyright © 2022 Viettel. All rights reserved.
//

import UIKit

class CCPortalHomeHeaderView : UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewMoreAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .white
    }
    
    
    @IBAction func addAddress(_ sender: Any) {
        viewMoreAction?()
    }
    
}
