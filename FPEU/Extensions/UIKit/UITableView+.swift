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
