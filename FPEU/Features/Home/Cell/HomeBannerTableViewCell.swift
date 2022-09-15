//
//  HomeBannerTableViewCell.swift
//  FPEU
//
//  Created by son on 12/09/2022.
//

import UIKit
import FSPagerView
import SDWebImage

class HomeBannerTableViewCell: UITableViewCell {

    @IBOutlet weak var fsPagerView: FSPagerView!
    
    var listBanner: [HomeBanner] = [] {
        didSet { self.fsPagerView.reloadData() }
    }
    
    override func awakeFromNib() {
        fsPagerView.delegate = self
        fsPagerView.dataSource = self
        fsPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.reuseIdentifier)
        fsPagerView.automaticSlidingInterval = 3
    }
    
}

extension HomeBannerTableViewCell: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return listBanner.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.reuseIdentifier, at: index)
        cell.imageView?.sd_setImage(with: URL(string: listBanner[index].imageUrl ?? ""), placeholderImage: UIImage(named: "placeholder_home_banner"))
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        guard let url = URL(string: listBanner[index].deepLink ?? "") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
