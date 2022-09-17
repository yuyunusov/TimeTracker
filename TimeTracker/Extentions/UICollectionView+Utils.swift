//
//  UICollectionView+Utils.swift
//  TimeTracker
//
//  Created by Yunus Yunusov on 18.09.2022.
//

import UIKit

extension UICollectionView {

    func insertOnTop() {
        insertItems(at: [IndexPath(item: 0, section: 0)])
    }
}
