//
//  GameReducer.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 31/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import ReSwift
import GameplayKit

private struct GameReducerConstants {
    static let numberOfUniqueCards = 8
}
private typealias C = GameReducerConstants

func gameReducer(action: Action, state: GameState?) -> GameState {
    var state = state ?? GameState(memoryCards: [], showLoading: false, gameFinished: false)
    
    switch(action) {
    case let setCardsAction as SetCardsAction:
        state.memoryCards = generateNewCards(with: setCardsAction.cardImageUrls)
        state.showLoading = false
    case let flipCardAction as FlipCardAction:
        state.memoryCards = flipCard(index: flipCardAction.cardIndexToFlip, memoryCards: state.memoryCards)
        state.gameFinished = hasFinishedGame(cards: state.memoryCards)
    case _ as FetchTunesAction:
        state = GameState(memoryCards: [], showLoading: true, gameFinished: false)
    default: break
    }
    
    return state
}

private func generateNewCards(with cardImageUrls:[String]) -> [MemoryCard] {
    var memoryCards = cardImageUrls[0..<C.numberOfUniqueCards].map { image -> MemoryCard in
        MemoryCard(imageUrl: image, isFlipped: false, isAlreadyGuessed: false)
    }
    
    memoryCards.append(contentsOf: memoryCards)
    return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: memoryCards) as! [MemoryCard]
}

private func flipCard(index: Int, memoryCards: [MemoryCard]) -> [MemoryCard] {
    var changedCards = memoryCards
    
    changedCards[index].isFlipped = true
    
    let alreadyFlippedCardsInGame = changedCards.filter({ card -> Bool in
        return !card.isAlreadyGuessed && card.isFlipped
    })
    
    if alreadyFlippedCardsInGame.count == 2 {
        let firstCardUrl = alreadyFlippedCardsInGame[0].imageUrl
        let secondCardUrl = alreadyFlippedCardsInGame[1].imageUrl
        
        let playerGuessedRight = firstCardUrl == secondCardUrl
        
        if playerGuessedRight {
            changedCards = checkGuessedCards(for: firstCardUrl, in: changedCards)
        }
    }
    
    if alreadyFlippedCardsInGame.count == 3 {
        changedCards = flipBackCards(changedCards, exceptIndex: index)
    }
    
    return changedCards
}

private func checkGuessedCards(for imageUrl: String, in cards: [MemoryCard]) -> [MemoryCard] {
    var changedCards = cards
    for index in 0 ..< cards.count {
        if cards[index].imageUrl == imageUrl {
            changedCards[index].isAlreadyGuessed = true
        }
    }
    
    return changedCards
}

private func flipBackCards(_ cards: [MemoryCard], exceptIndex: Int) -> [MemoryCard] {
    var changedCards = cards
    for index in 0 ..< cards.count {
        if index != exceptIndex {
            changedCards[index].isFlipped = false
        }
    }
    
    return changedCards
}

private func hasFinishedGame(cards: [MemoryCard]) -> Bool {
    
    for card in cards {
        if !card.isAlreadyGuessed {
            return false
        }
    }
    
    return true
}
