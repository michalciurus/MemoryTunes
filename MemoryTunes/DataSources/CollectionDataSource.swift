/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
        
        guard let currentCell = cell else {
            fatalError("Identifier or class not registered with this collection view")
        }
        
        let model = models[indexPath.row]
        var lastModel: T? = nil
        if lastModels?.indices.contains(indexPath.row) == true {
            lastModel = lastModels![indexPath.row]
        }
        return configureCell(currentCell, model, lastModel)
        
    }
}
