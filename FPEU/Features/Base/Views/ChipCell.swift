//
//  ChipCell.swift
//  FPEU
//
//  Created by son on 13/09/2022.
//

import UIKit

struct ChipProperty {
    var textColor: UIColor = .black
    var selectedTextColor: UIColor = .black
    var selectedBackgroundColor: UIColor = .lightGray
    var backgroundColor: UIColor = .gray
    var borderWidth: CGFloat = 0
    var borderColor: UIColor?
}

class ChipCell: UICollectionViewCell {
    
    @IBOutlet private weak var chipView: UIView!
    @IBOutlet private weak var label: UILabel!
    var chipProperty: ChipProperty! {
        didSet { initUI() }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        chipView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        chipView.layer.cornerRadius = self.bounds.size.height / 2
    }
    
    var isChipSelected: Bool = false {
        didSet {
            setSelectedState()
        }
    }
    
    private func initUI() {
        
        label.textColor = chipProperty.textColor
        chipView.backgroundColor = chipProperty.backgroundColor
        
        chipView.layer.borderWidth = chipProperty.borderWidth
        chipView.layer.borderColor = chipProperty.borderColor?.cgColor
    }
    
    private func setSelectedState() {
        chipView.backgroundColor = isChipSelected ? chipProperty.selectedBackgroundColor : chipProperty.backgroundColor
        
        label.textColor = isChipSelected ? chipProperty.selectedTextColor : chipProperty.textColor
    }

    func setText(_ text: String) {
        label.text = text
    }
}
