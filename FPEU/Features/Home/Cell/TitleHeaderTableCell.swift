//
//  TitleHeaderTableCell.swift
//  FPEU
//
//  Created by son on 12/09/2022.
//

import UIKit

class TitleHeaderTableCell: UITableViewHeaderFooterView {

    @IBOutlet private weak var labelHeader: UILabel!
    @IBOutlet weak var labelLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelTrailingContraint: NSLayoutConstraint!
    var labelMargin: Int = 0 {
        didSet { setMargin() }
    }
    
    override func awakeFromNib() {
        contentView.backgroundColor = .white
        labelHeader.backgroundColor = .white
    }
    
    func setText(_ text: String) {
        labelHeader.text = text
    }
    
    private func setMargin() {
        labelLeadingConstraint.constant = CGFloat(labelMargin)
        labelTrailingContraint.constant = CGFloat(labelMargin)
    }
}
