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
import ReSwift

final class GameViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  var hasFinishedGame: Bool = false
  
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
  
  fileprivate func showGameFinishedAlert() {
    let alertController = UIAlertController(title: "Congratulations!", message: "You've finished the game!", preferredStyle: .alert)
    
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    
    present(alertController, animated: true, completion: nil)
  }
}

// MARK: - StoreSubscriber
extension GameViewController: StoreSubscriber {
  func newState(state: GameState) {
    
    collectionDataSource?.models = state.memoryCards
    collectionView.reloadData()
    
    state.showLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    
    let gameFinishedStateChanged = state.gameFinished && !self.hasFinishedGame
    
    if gameFinishedStateChanged {
      hasFinishedGame = true
      showGameFinishedAlert()
    }
  }
}

// MARK: - UICollectionViewDelegate
extension GameViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    store.dispatch(FlipCardAction(cardIndexToFlip: indexPath.row))
  }
}
