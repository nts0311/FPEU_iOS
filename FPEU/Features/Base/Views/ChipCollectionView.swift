//
//  ChipCollectionView.swift
//  FPEU
//
//  Created by son on 13/09/2022.
//

import UIKit

@IBDesignable
class ChipCollectionView: UIView {
    
    private var collectionView: UICollectionView!
    
    @IBInspectable open dynamic var textColor: UIColor = .black {
        didSet {
            reloadData()
        }
    }
    
    @IBInspectable open dynamic var selectedTextColor: UIColor = .black {
        didSet {
            reloadData()
        }
    }
    
    @IBInspectable open dynamic var selectedBackgroundColor: UIColor = .black {
        didSet {
            reloadData()
        }
    }
    
    @IBInspectable open dynamic var chipBackgroundColor: UIColor = UIColor.gray {
        didSet {
            reloadData()
        }
    }
    
    @IBInspectable open dynamic var borderWidth: CGFloat = 0 {
        didSet {
            reloadData()
        }
    }
    
    @IBInspectable open dynamic var borderColor: UIColor? {
        didSet {
            reloadData()
        }
    }
    
    private var chips: [Chip] = []
    
    var onClickListener: ((Int) -> Void)? = nil
    
    var selectedIndex: Int? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    private func initViews() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: collectionViewLayout)
        
        collectionView.register(ChipCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsMultipleSelection = false
        
        self.addSubview(collectionView)
        
    }
    
    func setListChip(_ chips: [Chip], onDone: (() -> Void)? = nil) {
        self.chips = chips
        collectionView.reloadData {
            onDone?()
        }
    }
    
    private func reloadData() {
        collectionView.reloadData()
    }
    
    func scrollToItem(index: Int) {
        collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .left, animated: true)
    }
    
    
}

extension ChipCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chipProperty = ChipProperty(textColor: textColor, selectedTextColor: selectedTextColor, selectedBackgroundColor: selectedBackgroundColor, backgroundColor: chipBackgroundColor, borderWidth: borderWidth, borderColor: borderColor)
        
        let cell: ChipCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.chipProperty = chipProperty
        cell.setText(chips[indexPath.row].title ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if (indexPath.row == selectedIndex) {
//            selectedIndex = nil
//            cell.isChipSelected = false
//        } else {
//
//            highlightItemAt(indexPath.row)
//        }
        
        highlightItemAt(indexPath.row)
        
        onClickListener?(indexPath.row)
    }
    
    func highlightItemAt(_ index: Int) {
        
        if let selectedIndex = selectedIndex, let selectedCell = collectionView.cellForItem(at: IndexPath.init(row: selectedIndex, section: 0)) as? ChipCell {
            selectedCell.isChipSelected = false
        }
        
        let highLightIndexPath = IndexPath.init(row: index, section: 0)
        if let cell = collectionView.cellForItem(at: highLightIndexPath) as? ChipCell {
            cell.isChipSelected = true
            selectedIndex = index
            scrollToItem(index: index)
        }
    }
}
