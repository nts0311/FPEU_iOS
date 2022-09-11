//
//  CCPortalTopicHomeTableViewCell.swift
//  ViettelPay
//
//  Created by Ngô Huân on 23/05/2022.
//  Copyright © 2022 Viettel. All rights reserved.
//

import UIKit

let PRODUCT_CATEGORY_CELL_HEIGHT = 95.0
let PRODUCT_CATEGORY_NUM_PER_ROW = 4

class ProductCategoryCollectionCell : UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var listCategory: [ProductCategory] = [] {
        didSet { self.initData() }
    }
    
    var didSelectCategory: ((ProductCategory) -> Void)?
    
    func initData() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ProductCategoryCell.self)
        self.collectionView.reloadData()
    }
    
    static func calCellHeight(numOfCategories: Int) -> Double {
        let numOfRows = (Double(numOfCategories) / Double(PRODUCT_CATEGORY_NUM_PER_ROW)).rounded(.up)
        return PRODUCT_CATEGORY_CELL_HEIGHT * Double(numOfRows) + 30.0 + 16
    }
}

extension ProductCategoryCollectionCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCategoryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.category = listCategory[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectCategory?(self.listCategory[indexPath.row])
    }
    
}

extension ProductCategoryCollectionCell : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 4.0 * 2) / Double(PRODUCT_CATEGORY_NUM_PER_ROW)
        return CGSize(width: width, height: PRODUCT_CATEGORY_CELL_HEIGHT)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
