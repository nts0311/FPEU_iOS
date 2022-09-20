//
//  CartDetailViewController.swift
//  FPEU
//
//  Created by son on 19/09/2022.
//

import UIKit
import RxSwift

class CartDetailViewController: FPViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numOfItemLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var paymentButton: UIControl!
    
    private let viewModel = CartDetailViewModel()
    
    var onDismissed: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    private func initView() {
        updateCartInfos()
        
        closeButton.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: self.onDismissed)
        }).disposed(by: disposeBag)
        
        clearButton.rx.tap.subscribe(onNext: {
            self.viewModel.clearCart()
            self.dismiss(animated: true, completion: self.onDismissed)
        }).disposed(by: disposeBag)
        
        tableView.register(cell: OrderedProductCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateCartInfos() {
        numOfItemLabel.text = "\(viewModel.getNumOfItemInCart()) Món"
        totalPriceLabel.text = viewModel.getTotalPrice()
    }
    
    @IBAction func buttonPaymentTapped(_ sender: Any) {
        
    }

}

extension CartDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orderedItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderedProductCell = tableView.dequeueReusableCell(at: indexPath)
        
        let orderedProduct = viewModel.orderedItem[indexPath.row]
        
        cell.onNewValue = {newNum in
            self.viewModel.changeNumOf(product: orderedProduct, newNum: newNum)
            self.updateCartInfos()
            self.tableView.reloadData()
        }
        cell.productItem = orderedProduct
        
        return cell
    }
    
}
