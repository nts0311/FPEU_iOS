//
//  MerchantViewController.swift
//  FPEU
//
//  Created by son on 12/09/2022.
//

import UIKit
import TagListView

fileprivate let INFO_SECTION = 0

class MerchantViewController: FPViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var menuListView: ChipCollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var cartView: UIView!
    
    private var viewModel = MerchantViewModel()
    
    private var lastOffsetY: CGFloat = 0.0
    private var isScrollingUp = false
    
    var merchantItem: MerchantItem! {
        didSet {
            viewModel.merchantItem = self.merchantItem
        }
    }
    
    var isSelfScrolling = false
    var selfScrollToSection: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindMerchantData()
        
        
        bindViewModel()
        viewModel.inLoad.accept(())
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupViews() {
        
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.sectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: MerchantInfoCell.self)
        tableView.register(cell: ProductItemCell.self)
        tableView.register(TitleHeaderTableCell.nib, forHeaderFooterViewReuseIdentifier: TitleHeaderTableCell.reuseIdentifier)
        
        menuListView.onClickListener = {
            self.isSelfScrolling = true
            self.selfScrollToSection = $0 + 1
            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: $0 + 1), at: .top, animated: true)
        }
        
        backButton.rx.tap.subscribe(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func bindMerchantData() {
        headerImageView.sd_setImage(with: merchantItem.imageUrl.url, placeholderImage: UIImage(named: "placeholder_boon_char"))
    }
    
    private func bindViewModel() {
        viewModel.outApiResult.asObservable()
            .subscribe(onNext: {_ in
                self.setupMenuList()
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupMenuList() {
        let chips = viewModel.menuList.map {
            Chip(title: $0.name)
        }
        menuListView.setListChip(chips, onDone: {
            self.menuListView.highlightItemAt(0)
        })
    }
    
    private func checkDisplayCart() {
        if (viewModel.needDisplayCartView()) {
            cartButton.layer.cornerRadius = 8
            cartButton.layer.borderWidth = 2
            cartButton.layer.borderColor = UIColor.mainColor.cgColor
            
            cartButton.setTitle("\(viewModel.getNumOfItemInCart())", for: .normal)
            orderButton.setTitle("Thanh toán - \(String(viewModel.getTotalPrice()).formatAmount ?? "")", for: .normal)
            
            cartView.isHidden = false
        } else {
            cartView.isHidden = true
        }
    }
}

extension MerchantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + viewModel.sectionedProductList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 1
        } else {
            return viewModel.getProductOfSection(section).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell: MerchantInfoCell = tableView.dequeueReusableCell(at: indexPath)
            cell.merchantItem = merchantItem
            return cell
        }
        
        if let product = viewModel.getProductAt(indexPath: indexPath) {
            let cell: ProductItemCell = tableView.dequeueReusableCell(at: indexPath)
            cell.product = product
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return CGFloat.leastNonzeroMagnitude
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooter(ofType: TitleHeaderTableCell.self)
        header.setText(viewModel.getMenuFor(section: section).name ?? "")
        header.labelMargin = 16
        return header
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        
        navBarView.alpha = y/100
        
        if (scrollView.contentOffset.y > lastOffsetY) {
                // Scroll down direction
                isScrollingUp = true
            } else {
                // Scroll to up
                isScrollingUp = false
            }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastOffsetY = scrollView.contentOffset.y
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if (isSelfScrolling && selfScrollToSection == section) {
            selfScrollToSection = nil
            isSelfScrolling = false
            return
        }
        
        if (isScrollingUp) {
            menuListView.highlightItemAt(section - 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        
        if (isSelfScrolling) {
            return
        }
        
        if (!isScrollingUp) {
            menuListView.highlightItemAt(section - 2)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == INFO_SECTION) {
            return
        }
        
        let vc = ProductDetailViewController.initFromNib()
        vc.product = viewModel.getProductAt(indexPath: indexPath)
        vc.onDissmissed = {
            self.checkDisplayCart()
        }
        present(vc, animated: true)
    }
}

enum MerchantTableViewSection: Int {
    case info = 0
    case product = 1
}
