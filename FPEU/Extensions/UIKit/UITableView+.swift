//
//  UITableView+.swift
//  FPEU
//
//  Created by son on 07/08/2022.
//

import Foundation
import UIKit

public extension UITableView {
    func register<T: UIView>(cell: T.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    func register<T: UIView>(headerFooter: T.Type) {
        register(headerFooter, forHeaderFooterViewReuseIdentifier: headerFooter.reuseIdentifier)
    }
    
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier,
                                             for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
    
    func dequeueReusableHeaderFooter<T>(ofType headerFooterType: T.Type = T.self) -> T where T: UITableViewHeaderFooterView {
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: headerFooterType.reuseIdentifier) as? T else {
            fatalError()
        }
        return headerFooter
    }
}

extension UITableView {
    
    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil {
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            
            if #available(iOS 13.0, *) {
                activityIndicatorView.style = .large
            } else {
                // Fallback on earlier versions
                activityIndicatorView.style = .whiteLarge
            }
            
            activityIndicatorView.color = .systemPink
            activityIndicatorView.hidesWhenStopped = true
            
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }
        else {
            return activityIndicatorView
        }
    }
    
    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
        indicatorView().startAnimating()
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closure()
                }
            }
        }
    }
    
    func stopLoading() {
        if self.tableFooterView != nil {
            self.indicatorView().stopAnimating()
            self.tableFooterView = nil
        }
        else {
            self.tableFooterView = nil
        }
    }
}
