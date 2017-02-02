//
//  FetchTunesAction.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 01/02/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import ReSwift

func fetchTunes(state: AppState, store: Store<AppState>) -> FetchTunesAction {
    
    iTunesAPI.searchFor(category: state.categoriesState.currentCategorySelected.rawValue) { imageUrls in
        store.dispatch(SetCardsAction(cardImageUrls: imageUrls))
    }

    return FetchTunesAction();
}

struct FetchTunesAction: Action {
}
