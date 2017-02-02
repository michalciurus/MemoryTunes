//
//  CategoriesState.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 31/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import ReSwift

enum Category: String {
    case pop = "Pop"
    case electronic = "Electronic"
    case rock = "Rock"
    case metal = "Metal"
    case rap = "Rap"
}

struct CategoriesState: StateType {
    let categories: [Category]
    var currentCategorySelected: Category
    
    init(currentCategory: Category) {
        categories = [ .pop, .electronic, .rock, .metal, .rap]
        currentCategorySelected = currentCategory
    }
}
