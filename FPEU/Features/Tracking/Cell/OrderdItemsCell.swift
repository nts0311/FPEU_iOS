//
//  OrderdItemsCell.swift
//  FPEU
//
//  Created by son on 13/10/2022.
//

import UIKit
import RxSwift

class OrderdItemsCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    
    var items: [OrderedItem] = [] {
        didSet { initData() }
    }
    
    var onHeightChanged: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.borderWidth = 1.0
        cardView.layer.borderColor = UIColor.systemGray5.cgColor
        tableView.register(cell: OrderedItemCell.self)
        tableView.dataSource = self
        tableView.rx.observe(CGSize.self, #keyPath(UITableView.contentSize))
            .subscribe(onNext: { contentSize in
                self.tableViewHeightConstraint.constant = contentSize?.height ?? 0
                self.onHeightChanged()
            })
            .disposed(by: disposeBag)
    }

    func initData() {
        tableView.reloadData()
    }
    
}

extension OrderdItemsCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderedItemCell = tableView.dequeueReusableCell(at: indexPath)
        cell.item = items[indexPath.row]
        return cell
    }
    
}
