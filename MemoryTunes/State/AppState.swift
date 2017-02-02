//
//  AppState.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 29/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    let routingState: RoutingState
    let menuState: MenuState
    let categoriesState: CategoriesState
    let gameState: GameState
}
