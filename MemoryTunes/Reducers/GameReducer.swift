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
