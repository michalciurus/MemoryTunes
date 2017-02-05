//
//  CardCollectionViewCell.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 01/02/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import UIKit
import Kingfisher

final class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardImageView: UIImageView!
    private var lastCardState: MemoryCard?
    
    func configureCell(with cardState: MemoryCard, lastCardState: MemoryCard?) {
        let url = URL(string: cardState.imageUrl)
        cardImageView.kf.setImage(with: url)
        
        if cardState.isAlreadyGuessed {
            cardImageView.alpha = 1
        } else {
            let wasVisible = lastCardState?.isFlipped ?? false
            animateCard(fromFlipState: wasVisible, toFlipState: cardState.isFlipped)
        }
    }
    
    private func animateCard(fromFlipState lastFlipState: Bool, toFlipState currentFlipState: Bool) {
        switch((lastFlipState, currentFlipState)) {
        case (false, true): animateShowCard()
        case (true, false): animateHideCard()
        case (true, true): cardImageView.alpha = 1
        case (false, false): cardImageView.alpha = 0
        }
    }
    
    private func animateShowCard() {
        self.cardImageView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.cardImageView.alpha = 1
        }
    }
    
    private func animateHideCard() {
        self.cardImageView.alpha = 1
        UIView.animate(withDuration: 0.3) {
            self.cardImageView.alpha = 0
        }
    }
}
