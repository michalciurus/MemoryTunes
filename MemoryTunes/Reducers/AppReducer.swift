//
//  AppReducer.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 29/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import ReSwift

struct AppReducer: Reducer {
    func handleAction(action: Action, state: AppState?) -> AppState {
        return AppState(
            routingState: routingReducer(action: action, state: state?.routingState),
            menuState: menuReducer(action: action, state: state?.menuState),
            categoriesState: categoriesReducer(action:action, state: state?.categoriesState),
            gameState: gameReducer(action: action, state: state?.gameState))
    }
}
