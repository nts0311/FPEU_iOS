//
//  MerchantListViewController.swift
//  FPEU
//
//  Created by son on 07/11/2022.
//

import UIKit
import RxRelay
import IQKeyboardManagerSwift

class MerchantListViewController: FPViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var categoryId: Int?
    
    let viewModel = MerchantListViewModel()
    
    private let loadMoreTrigger = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
    }

    private func setupViews() {
        navigationItem.title = "Danh sách nhà hàng"
        setDoneOnKeyboard()
        if (categoryId == nil) {
            searchBar.becomeFirstResponder()
        }
        
        tableView.register(cell: MerchantItemTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        searchBar.inputAccessoryView = keyboardToolbar
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func bindViewModel() {
        let searchTextTrigger = PublishRelay<String?>()
        searchBar.rx.text
            .bind(to: searchTextTrigger)
            .disposed(by: disposeBag)
        let input = MerchantListViewModel.Input(categoryId: categoryId, loadMoreTrigger: loadMoreTrigger, searchTextTrigger: searchTextTrigger)
        let output = viewModel.transform(input: input)
        
        output.loadDataDone.asObservable()
            .subscribe(onNext:{
                self.tableView.reloadData()
                self.tableView.stopLoading()
            })
            .disposed(by: disposeBag)
        
        input.loadMoreTrigger.accept(())
    }
    

}

extension MerchantListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.merchantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MerchantItemTableViewCell = tableView.dequeueReusableCell(at: indexPath)
        cell.merchantItem = viewModel.merchantList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (!viewModel.canLoadMore()) {
            return
        }
        
        tableView.addLoading(indexPath) {
            self.loadMoreTrigger.accept(())
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row >= viewModel.merchantList.count) {
            return
        }
        
        MerchantViewController.showOn(navigationController, with: viewModel.merchantList[indexPath.row])
    }

}

extension MerchantListViewController {
    public static func showOn(_ navController: UINavigationController?, with categoryId: Int? = nil) {
        let vc = MerchantListViewController.initFromNib()
        vc.categoryId = categoryId
        navController?.pushViewController(vc, animated: true)
    }
}
