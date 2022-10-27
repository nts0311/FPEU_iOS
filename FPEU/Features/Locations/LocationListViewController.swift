//
//  LocationListViewController.swift
//  FPEU
//
//  Created by son on 24/10/2022.
//

import UIKit

class LocationListViewController: FPViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = LocationListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initData()
    }
    
    private func setupView() {
        navigationItem.title = "Danh sách địa chỉ"
        let headerNibName = String(describing: CCPortalHomeHeaderView.self)
        self.tableView.register(UINib(nibName: headerNibName, bundle: nil), forHeaderFooterViewReuseIdentifier: headerNibName)
        tableView.register(cell: LocationCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func initData() {
        viewModel.getListLocation().subscribe(onSuccess: {_ in
            self.tableView.reloadData()
        }, onFailure: {_ in
            
        }).disposed(by: disposeBag)
    }
    
}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationCell = tableView.dequeueReusableCell(at: indexPath)
        cell.address = viewModel.locations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerNibName = String(describing: CCPortalHomeHeaderView.self)
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerNibName) as? CCPortalHomeHeaderView {
            headerView.viewMoreAction = {
                let vc = AddAddressViewController.initFromNib()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setAddress(index: indexPath.row)
        navigationController?.popViewController(animated: true)
    }
    
}

extension LocationListViewController {
    static func showOn(_ navController: UINavigationController?) {
        let vc = LocationListViewController.initFromNib()
        navController?.pushViewController(vc, animated: true)
    }
}
