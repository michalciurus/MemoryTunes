//
//  RoutingState.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 31/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import ReSwift

struct RoutingState: StateType {
    var navigationState: RoutingDestination
    
    init(navigationState: RoutingDestination = .menu) {
        self.navigationState = navigationState
    }
}
