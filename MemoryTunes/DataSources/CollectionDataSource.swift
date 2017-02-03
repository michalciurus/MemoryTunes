//
//  CollectionDataSource.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 01/02/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import UIKit

final class CollectionDataSource<V, T>: NSObject, UICollectionViewDataSource where V: UICollectionViewCell {
    
    typealias CellConfiguration = (V, T) -> V
    
    private let array: [T]
    private let configureCell: CellConfiguration
    private let cellIdentifier: String
    
    init(cellIdentifier: String, models: [T], configureCell: @escaping CellConfiguration) {
        self.array = models
        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? V
        
        if let cell = cell {
            let model = array[indexPath.row]
            return configureCell(cell, model)
        } else {
            fatalError("Identifier or class not registered with this collection view")
        }
    }
}
