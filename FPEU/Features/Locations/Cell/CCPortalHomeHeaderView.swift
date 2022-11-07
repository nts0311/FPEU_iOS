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
    @IBOutlet weak var viewMoreButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    
    var viewMoreAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .white
        hiddenViewMoreButton(true)
    }
    
    func initView() {
        self.viewMoreButton.setTitle("Xem thêm", for: .normal)
    }
    
    @IBAction func moreTouchUpInside(_ sender: Any) {
        self.viewMoreAction?()
    }
    
    func hiddenViewMoreButton(_ isHidden: Bool) {
        self.viewMoreButton.isHidden = isHidden
        self.arrowImage.isHidden = isHidden
    }
    
}
