//
//  UITableViewExtension.swift
//  Squab
//
//  Created by Chandrachudh on 24/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func animateAndReload() {
        reloadData()
        alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 1.0
        }) { (finished) in
        }
    }
}

extension UICollectionView {
    func animateAndReload() {
        reloadData()
        alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 1.0
        }) { (finished) in
        }
    }
}
