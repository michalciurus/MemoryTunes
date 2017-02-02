//
//  GameViewController.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 31/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import UIKit
import ReSwift
import Kingfisher

final class GameViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    }
}

extension GameViewController: StoreSubscriber {
    func newState(state: GameState) {
        collectionDataSource = CollectionDataSource(cellIdentifier: "CardCell", models: state.memoryCards, configureCell: { (cell, model) -> CardCollectionViewCell in
            let url = URL(string: model.imageUrl)
            cell.cardImageView.kf.setImage(with: url)
            cell.cardImageView.isHidden = !(model.isFlipped || model.isAlreadyGuessed)
            return cell
        })
        
        collectionView.dataSource = collectionDataSource
        collectionView.reloadData()
    }
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        store.dispatch(FlipCardAction(cardIndexToFlip: indexPath.row))
    }
}
