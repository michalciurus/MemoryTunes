//
//  GameReducer.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 31/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import ReSwift
import GameplayKit

fileprivate struct GameReducerConstants {
    static let numberOfUniqueCards = 8
}
fileprivate typealias C = GameReducerConstants

func gameReducer(action: Action, state: GameState?) -> GameState {
    var state = state ?? GameState(memoryCards: [])
    
    switch(action) {
    case let setCardsAction as SetCardsAction:
        state.memoryCards = generateNewCards(with: setCardsAction.cardImageUrls)
    case let flipCardAction as FlipCardAction:
        state.memoryCards = flipCard(index: flipCardAction.cardIndexToFlip, memoryCards: state.memoryCards)
    case _ as FetchTunesAction:
        state.memoryCards = []
    default: break
    }
    
    return state
}

fileprivate func generateNewCards(with cardImageUrls:[String]) -> [MemoryCard] {
    var memoryCards = cardImageUrls[0..<C.numberOfUniqueCards].map { image -> MemoryCard in
        MemoryCard(imageUrl: image, isFlipped: false, isAlreadyGuessed: false)
    }
    
    memoryCards.append(contentsOf: memoryCards)
    return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: memoryCards) as! [MemoryCard]
}

fileprivate func flipCard(index: Int,memoryCards: [MemoryCard]) -> [MemoryCard] {
    var changedCards = memoryCards
    
    let cardsInGame = changedCards.filter({ card -> Bool in
        return !card.isAlreadyGuessed
    })
    
    var alreadyFlippedCards = cardsInGame.filter { card -> Bool in
        return card.isFlipped
    }
    
    if alreadyFlippedCards.count == 2 {
        let firstCardUrl = alreadyFlippedCards[0].imageUrl
        let secondCardUrl = alreadyFlippedCards[1].imageUrl
        
        let playerGuessedRight = firstCardUrl == secondCardUrl
        
        if playerGuessedRight {
            changedCards = checkGuessedCards(for: firstCardUrl, in: changedCards)
        }
        
        changedCards = flipBackCards(changedCards)
    }
    
    changedCards[index].isFlipped = true
    
    return changedCards
}

fileprivate func checkGuessedCards(for imageUrl: String, in cards: [MemoryCard]) -> [MemoryCard] {
    var changedCards = cards
    for index in 0 ..< cards.count {
        if cards[index].imageUrl == imageUrl {
            changedCards[index].isAlreadyGuessed = true
        }
    }
    
    return changedCards
}

fileprivate func flipBackCards(_ cards: [MemoryCard]) -> [MemoryCard] {
    var changedCards = cards
    for index in 0 ..< cards.count {
        changedCards[index].isFlipped = false
    }
    
    return changedCards
}
