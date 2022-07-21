//
//  AppCoordinator.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 20/07/2022.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    func start()
}

final class AppCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        let searchDrinkCoordinator = SearchDrinkCoordinator(navigationController: navigationController)
        
        // Added to childCoordinators otherwise will be immadiately deallocated
        childCoordinators.append(searchDrinkCoordinator)
        
        // Added searchDrinkViewController to navigation stack as the root
        searchDrinkCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
}
