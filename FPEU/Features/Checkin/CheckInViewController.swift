//
//  CheckInViewController.swift
//  FPEU
//
//  Created by son on 20/09/2022.
//

import UIKit

class CheckInViewController: FPViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPricelabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var paymentMethodImage: UIImageView!
    
    let viewModel = CheckinViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindViewModel()
        viewModel.getOrderCheckinInfo()
    }

    private func setupView() {
        tableView.register(cell: CheckInAddressCell.self)
        tableView.register(cell: OrderedProductCell.self)
        tableView.register(cell: PaymentDetailCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.title = "Thông tin đơn hàng"
    }
    
    private func bindViewModel() {
        viewModel.outApiResult.asObservable()
        .subscribe(onNext: {_ in
            self.reloadData()
        })
        .disposed(by: disposeBag)
        
        viewModel.outPlaceOrderSuccess.asObservable()
            .subscribe(onNext: {
                OrderTrackingViewController.showOn(self.navigationController)
            })
            .disposed(by: disposeBag)
        
        placeOrderButton.rx.tap.bind(to: viewModel.inButtonPlaceOrderTapped).disposed(by: disposeBag)
    }
    
    private func reloadData() {
        if let paymentDetail = viewModel.paymentInfo {
            totalPricelabel.text = String(paymentDetail.toPaymentDetail().totalPayment).formatAmount
            paymentMethodLabel.text = "Tiền mặt"
        }
        
        self.tableView.reloadData()
    }
}

extension CheckInViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableViewSection.init(rawValue: section) {
        case .address:
            return 1
        case .orderItems:
            return viewModel.orderedItem.count
        case .paymentDetail:
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableViewSection.init(rawValue: indexPath.section) {
        case .address:
            let currentAddress = viewModel.getSelectedAddress()
            let cell: CheckInAddressCell = tableView.dequeueReusableCell(at: indexPath)
            cell.address = currentAddress!
            cell.estimatedRouteInfo = viewModel.estimatedRouteInfo
            return cell
        case .orderItems:
            let cell: OrderedProductCell = tableView.dequeueReusableCell(at: indexPath)
            
            let orderedProduct = viewModel.orderedItem[indexPath.row]
            
            cell.onNewValue = {newNum in
                self.viewModel.changeNumOf(product: orderedProduct, newNum: newNum)
                self.tableView.reloadData()
            }
            cell.productItem = orderedProduct
            
            return cell
        case .paymentDetail:
            let cell: PaymentDetailCell = tableView.dequeueReusableCell(at: indexPath)
            if let paymentInfo = viewModel.paymentInfo {
                let paymentDetail = paymentInfo.toPaymentDetail()
                cell.paymentDetail = paymentDetail
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

fileprivate enum TableViewSection: Int {
    case address = 0
    case orderItems
    //case promo
    case paymentDetail
}
