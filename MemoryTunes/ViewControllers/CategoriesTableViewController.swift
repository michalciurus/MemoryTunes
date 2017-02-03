//
//  CategoriesTableViewController.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 31/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import UIKit
import ReSwift

final class CategoriesTableViewController: UITableViewController {
    
    var tableDataSource: TableDataSource<UITableViewCell, Category>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self) { state in
            state.categoriesState
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(ChangeCategoryAction(categoryIndex: indexPath.row))
    }
}

extension CategoriesTableViewController: StoreSubscriber {
    func newState(state: CategoriesState) {
        tableDataSource = TableDataSource(cellIdentifier:"CategoryCell", models: state.categories) {cell, model in
            cell.textLabel?.text = model.rawValue
            cell.accessoryType = (state.currentCategorySelected == model) ? .checkmark : .none
            return cell
        }
        
        self.tableView.dataSource = tableDataSource
        self.tableView.reloadData()
    }
}
