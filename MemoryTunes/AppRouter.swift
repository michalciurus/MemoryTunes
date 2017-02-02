//
//  AppRouter.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 31/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import ReSwift

enum RoutingDestination {
    case menu
    case categories
    case game
}

final class AppRouter: StoreSubscriber {
    
    let navigationController: UINavigationController
    
    init(window: UIWindow) {
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        store.subscribe(self) { state in
            state.routingState
        }
    }
    
    func newState(state: RoutingState) {
        let shouldAnimate = navigationController.topViewController != nil
        navigateTo(destination: state.navigationState, animated: shouldAnimate)
    }
    
    private func navigateTo(destination: RoutingDestination, animated: Bool) {
        switch(destination) {
        case .categories: pushViewController(identifier: "CategoriesTableViewController", animated: animated)
        case .menu: pushViewController(identifier: "MenuTableViewController", animated: animated)
        case .game: pushViewController(identifier: "GameViewController", animated: animated)
        }
    }
    
    private func pushViewController(identifier: String, animated: Bool) {
        let viewController = instantiateViewController(identifier: identifier)
        let newViewControllerType = type(of: viewController)
        var shouldPush = true
        if let currentVc = navigationController.topViewController {
            let currentViewControllerType = type(of: currentVc)
            if currentViewControllerType == newViewControllerType {
                shouldPush = false
            }
        }
        
        if shouldPush {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }
    
    private func instantiateViewController(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
