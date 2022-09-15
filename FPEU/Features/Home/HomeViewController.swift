//
//  ViewController.swift
//  FPEU
//
//  Created by son on 07/08/2022.
//

import UIKit
import Alamofire
import RxSwift
import StompClientLib
import GoogleMaps

class HomeViewController: FPViewController {

    
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = HomeViewModel()
    
    //DATA
    private var banners = [HomeBanner]()
    private var categories = [ProductCategory]()
    private var homeSections = [HomeSection]()
    private var nearbyRestaurants = [MerchantItem]()
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        if UserDataDefaults.shared.isLoggedIn {
            viewModel.inLoadHomeInfo.accept(())
        } else {
           showLoginScreen()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func bindViewModel() {
        viewModel.outHomeInfo.asObservable()
            .subscribe(onNext: {(productCategories, homeSections, nearbyRestaurants, banners) in
                self.banners = banners
                self.categories = productCategories
                self.homeSections = homeSections
                self.nearbyRestaurants = nearbyRestaurants
                self.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func setupViews() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.tableFooterView = nil
        tableView.tableHeaderView = nil
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: ProductCategoryCollectionCell.self)
        tableView.register(cell: HomeSectionCell.self)
        tableView.register(cell: MerchantItemTableViewCell.self)
        tableView.register(cell: HomeBannerTableViewCell.self)
        tableView.register(TitleHeaderTableCell.nib, forHeaderFooterViewReuseIdentifier: TitleHeaderTableCell.reuseIdentifier)
    }
    
    private func reloadData() {
        labelAddress.text = UserRepo.shared.currentUserAddress?.toString()
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.isLoading ? 1 : 2 + homeSections.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch HomeTableViewSection.init(rawValue: section) {
        case .banner:
            return 1
        case .categories:
            return 1
            
        case .homeSection:
            return homeSections.count
            
        case .nearbyRestaurant:
            return nearbyRestaurants.count
            
        default:
            return 0
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch HomeTableViewSection.init(rawValue: indexPath.section) {
        case .banner:
            let cell: HomeBannerTableViewCell = tableView.dequeueReusableCell(at: indexPath)
            cell.listBanner = banners
            return cell
        case .categories:
            let categoriesCell: ProductCategoryCollectionCell = tableView.dequeueReusableCell(at: indexPath)
            categoriesCell.listCategory = categories
            categoriesCell.didSelectCategory = {category in
                
            }
            return categoriesCell
            
        case .homeSection:
            let cell: HomeSectionCell = tableView.dequeueReusableCell(at: indexPath)
            cell.homeSection = homeSections[indexPath.row]
            cell.diSelectMerchant = {restaurant in
                let vc = MerchantViewController.initFromNib()
                vc.merchantItem = restaurant
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
            
        case .nearbyRestaurant:
            let cell: MerchantItemTableViewCell = tableView.dequeueReusableCell(at: indexPath)
            cell.merchantItem = nearbyRestaurants[indexPath.row]
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.isLoading) {
            return 650
        }
        
        switch HomeTableViewSection.init(rawValue: indexPath.section) {
        case .categories:
            return ProductCategoryCollectionCell.calCellHeight(numOfCategories: self.categories.count)
            
        case .banner:
            return UITableView.automaticDimension
        case .homeSection:
            return UITableView.automaticDimension
        case .nearbyRestaurant:
            return UITableView.automaticDimension
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (self.isLoading) {
            return CGFloat.leastNonzeroMagnitude
        }
        
        switch HomeTableViewSection.init(rawValue: section) {
            
        case .nearbyRestaurant:
            return UITableView.automaticDimension
            
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.isLoading) {
            return nil
        }
        
        switch HomeTableViewSection.init(rawValue: section) {
        case .nearbyRestaurant:
            let header = tableView.dequeueReusableHeaderFooter(ofType: TitleHeaderTableCell.self)
                header.setText("Gần đây có gì nhon?")
                return header
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
}

enum HomeTableViewSection: Int {
    case banner = 0
    case categories = 1
    case homeSection = 2
    case nearbyRestaurant = 3
}
