//
//  HomeSectionCell.swift
//  FPEU
//
//  Created by son on 11/09/2022.
//

import UIKit

class HomeSectionCell: UITableViewCell {
    
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelSubtitle: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var cvFlowLayout: UICollectionViewFlowLayout!
    
    var diSelectMerchant: ((MerchantItem) -> Void)?
    
    var homeSection: HomeSection! {
        didSet {
            initData()
        }
    }
    
    override func awakeFromNib() {
        collectionView.register(MerchantItemCVCell.self)
        collectionView.register(HomeSectionFooterView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeSectionFooterView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        cvFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        cvFlowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    private func initData() {
        labelName.text = homeSection.name
        labelSubtitle.text = homeSection.description
        collectionView.reloadData()
    }
}

extension HomeSectionCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeSection.listMerchant.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MerchantItemCVCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.merchantItem = homeSection.listMerchant[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.diSelectMerchant?(homeSection.listMerchant[indexPath.row])
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:

            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeSectionFooterView.reuseIdentifier,
                for: indexPath)
            
            return footerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: 138, height: 100)
        
    }
}

