//
//  RoutingReducer.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 31/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import ReSwift

func routingReducer(action: Action, state: RoutingState?) -> RoutingState {
    var state = state ?? RoutingState()
    
    switch action {
        case let routingAction as RoutingAction:
          state.navigationState = routingAction.destination
        default: break
    }
    
    return state
}
