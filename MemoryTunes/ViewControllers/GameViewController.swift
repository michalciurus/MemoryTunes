//
//  GameViewController.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 31/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import UIKit
import ReSwift

final class GameViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var collectionDataSource: CollectionDataSource<CardCollectionViewCell, MemoryCard>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) { state in
            state.gameState
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    override func viewDidLoad() {
        store.dispatch(fetchTunes)
        collectionView.delegate = self
        loadingIndicator.hidesWhenStopped = true
        
        collectionDataSource = CollectionDataSource(cellIdentifier: "CardCell", models: [], configureCell: { (cell, model, lastModel) -> CardCollectionViewCell in
            cell.configureCell(with: model, lastCardState: lastModel)
            return cell
        })
        collectionView.dataSource = collectionDataSource
    }
}

extension GameViewController: StoreSubscriber {
    func newState(state: GameState) {

        collectionDataSource?.models = state.memoryCards
        collectionView.reloadData()
        
        state.showLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        store.dispatch(FlipCardAction(cardIndexToFlip: indexPath.row))
    }
}
