//
//  UICollectionView+.swift
//  FPEU
//
//  Created by son on 10/09/2022.
//

import UIKit

public extension UICollectionView {
  
  func register<T: UICollectionViewCell>(_: T.Type, bundle: Foundation.Bundle? = nil) {
    
      let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
      register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }
    
    return cell
  }
}

public extension UICollectionView {
    
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}
