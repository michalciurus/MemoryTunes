//
//  MenuState.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 29/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import ReSwift

struct MenuState: StateType {
    var menuTitles: [String]
    
    init() {
        menuTitles = ["New Game 🎲", "Choose Category 🎵"];
    }
}
