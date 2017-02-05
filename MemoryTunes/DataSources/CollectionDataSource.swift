//
//  CollectionDataSource.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 01/02/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import UIKit

/// This class is a mutable, declarative data source for UICollectionView
/// Apart from the current models array, it contains the last models array
/// to give the `CellConfiguration` a chance to calculate and react on differences in state
final class CollectionDataSource<V, T>: NSObject, UICollectionViewDataSource where V: UICollectionViewCell {
    
    typealias CellConfiguration = (V, T, T?) -> V
    
    var models: [T] {
        willSet {
            lastModels = models
        }
    }
    
    private var lastModels: [T]?
    private let configureCell: CellConfiguration
    private let cellIdentifier: String
    
    init(cellIdentifier: String, models: [T], configureCell: @escaping CellConfiguration) {
        self.models = models
        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? V
        
        if let cell = cell {
            let model = models[indexPath.row]
            var lastModel: T? = nil
            if lastModels?.indices.contains(indexPath.row) == true {
                lastModel = lastModels![indexPath.row]
            }
            return configureCell(cell, model, lastModel)
        } else {
            fatalError("Identifier or class not registered with this collection view")
        }
    }
}
