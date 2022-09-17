//
//  ProductDetailViewController.swift
//  FPEU
//
//  Created by son on 16/09/2022.
//

import UIKit

fileprivate let INFO_SECTION = 0

class ProductDetailViewController: FPViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var navbar: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    let viewModel = ProductDetailViewModel()
    
    var product: MerchantProduct! {
        didSet {
            viewModel.product = self.product
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.isNavigationBarHidden = true
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
        tableView.register(cell: ProductInfoCell.self)
        tableView.register(cell: ProductOptionCell.self)
        tableView.register(ProductAttributeHeader.nib, forHeaderFooterViewReuseIdentifier: ProductAttributeHeader.reuseIdentifier)
        
        buttonBack.rx.tap.subscribe(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.canAddToCard.asObservable()
            .bind(to: addToCartButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.canAddToCard.asObservable()
            .map { $0 ? UIColor.mainColor : UIColor.lightGray }
            .bind(to: addToCartButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.canAddToCard.asObservable()
            .map { $0 ? "Thêm vào giỏ" : "Chọn topping" }
            .bind(to: addToCartButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
}

extension ProductDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + viewModel.product.attributes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case INFO_SECTION:
            return 1
            
        default:
            return viewModel.getOptionsForAtrribute(index: section - 1).count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case INFO_SECTION:
            let cell: ProductInfoCell = tableView.dequeueReusableCell(at: indexPath)
            cell.product = viewModel.product
            return cell
            
        default:
            let cell: ProductOptionCell = tableView.dequeueReusableCell(at: indexPath)
            let attrIndex = indexPath.section - 1
            let optionIndex = indexPath.row
            cell.option = viewModel.getOptionAt(attributeIndex: attrIndex, optionIndex: optionIndex)
            cell.setChecked(viewModel.isOptionSelected(attributeIndex: attrIndex, optionIndex: optionIndex))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == INFO_SECTION) {
            return CGFloat.leastNonzeroMagnitude
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == INFO_SECTION) {
            return nil
        }
        
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductAttributeHeader.reuseIdentifier) as? ProductAttributeHeader {
            header.productAttribute = viewModel.getAttributeAt(index: section - 1)
            return header
        }
       
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? ProductOptionCell {
            let attrIndex = indexPath.section - 1
            let optionIndex = indexPath.row
            viewModel.changeOptionsState(attributeIndex: attrIndex, optionIndex: optionIndex)
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        navbar.alpha = y/100
    }
    
}

