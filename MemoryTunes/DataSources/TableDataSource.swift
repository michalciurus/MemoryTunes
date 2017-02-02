//
//  TableDataSource.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 30/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import UIKit

final class TableDataSource<V, T> : NSObject, UITableViewDataSource where V: UITableViewCell {
    
    typealias CellConfiguration = (V, T) -> V
    
    private let array: [T]
    private let configureCell: CellConfiguration
    private let cellIdentifier: String
    
    init(cellIdentifier: String, models: [T], configureCell: @escaping CellConfiguration) {
        self.array = models
        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? V
        if let cell = cell {
            let model = array[indexPath.row]
            return configureCell(cell, model)
        } else {
            fatalError("Identifier or class not registered with this table view")
        }
    }
}