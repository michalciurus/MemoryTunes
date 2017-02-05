//
//  GameState.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 31/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import ReSwift

struct MemoryCard {
    let imageUrl: String
    var isFlipped: Bool
    var isAlreadyGuessed: Bool
}

struct GameState: StateType {
    var memoryCards: [MemoryCard]
    var showLoading: Bool
}
