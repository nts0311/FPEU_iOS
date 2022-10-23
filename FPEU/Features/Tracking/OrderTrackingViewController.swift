//
//  OrderTrackingViewController.swift
//  FPEU
//
//  Created by son on 11/10/2022.
//

import UIKit

class OrderTrackingViewController: FPViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = OrderTrackingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cell: OrderStatusCell.self)
        tableView.register(cell: DeliveringDetailCell.self)
        tableView.register(cell: OrderdItemsCell.self)
        tableView.register(cell: PaymentDetailCell.self)
        tableView.dataSource = self
        
        navigationItem.title = "Theo dõi đơn hàng"
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.orderStatusRelay.asObservable()
            .filter { status in status != .unknown}
            .subscribe(onNext: {status in
                self.tableView.beginUpdates()
                self.tableView.reloadSections(IndexSet(integer: TableViewSection.orderStatus.rawValue), with: .none)
                switch status  {
                case .preparing:
                    self.tableView.reloadSections(IndexSet(integer: TableViewSection.deliveryDetail.rawValue), with: .none)
                case .succeed:
                    self.onOrderSuccessed()
                default: ()
                }
                self.tableView.endUpdates()
            })
            .disposed(by: disposeBag)
        
        viewModel.getOrderInfo().subscribe(onSuccess: {
            guard let orderInfo = $0 else {
                return
            }
            
            self.tableView.reloadData()
        })
        .disposed(by: disposeBag)
    }

    func onOrderSuccessed() {
        //OrderRepo.shared.orderInfo = nil
        showAlertDialog(title: "Hoàn thành", message: "Đơn hàng đã hoàn thành! Hãy đánh giá trải nghiệm của bạn nhé!", firstActionTitle: "Đánh giá", secondActionTitle: "Về trang chủ", firstAction: {
            
        }, secondAction: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
}

extension OrderTrackingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (viewModel.orderInfo != nil) ? 4 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableViewSection.init(rawValue: indexPath.section) {
        case .orderStatus:
            let cell: OrderStatusCell = tableView.dequeueReusableCell(at: indexPath)
            cell.setOrderStatus(orderStatus: viewModel.getOrderStatus())
            return cell
        case .deliveryDetail:
            let cell: DeliveringDetailCell = tableView.dequeueReusableCell(at: indexPath)
            cell.orderInfo = viewModel.orderInfo
            return cell
        case .orderedItemList:
            let cell: OrderdItemsCell = tableView.dequeueReusableCell(at: indexPath)
            cell.items = viewModel.getOrderedItemList()
            cell.layoutIfNeeded()
            return cell
        case .paymentDetail:
            let cell: PaymentDetailCell = tableView.dequeueReusableCell(at: indexPath)
            cell.paymentDetail = viewModel.getPaymentDetail()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

extension OrderTrackingViewController {
    static func showOn(_ navController: UINavigationController?) {
        let vc = OrderTrackingViewController.initFromNib()
        navController?.pushViewController(vc, animated: true)
    }
}

fileprivate enum TableViewSection: Int {
    case orderStatus = 0
    case deliveryDetail = 1
    case orderedItemList = 2
    case paymentDetail = 3
}
