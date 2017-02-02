//
//  MenuTableViewController.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 29/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import UIKit
import ReSwift

final class MenuTableViewController: UITableViewController {

    var tableDataSource: TableDataSource<UITableViewCell, String>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        store.subscribe(self) { state in
            state.menuState
        }
        
        //Updating the store manually
        store.dispatch(RoutingAction(destination: .menu))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var routeDestination: RoutingDestination = .categories
        switch(indexPath.row) {
            case 0: routeDestination = .game
            case 1: routeDestination = .categories
            default: break
        }
        
        store.dispatch(RoutingAction(destination: routeDestination))
    }
}

extension MenuTableViewController: StoreSubscriber {
    
    func newState(state: MenuState) {
        tableDataSource = TableDataSource(cellIdentifier:"TitleCell", models: state.menuTitles) {cell, model in
            cell.textLabel?.text = model
            cell.textLabel?.textAlignment = .center
            return cell
        }
        
        tableView.dataSource = tableDataSource
        tableView.reloadData()
    }
}
