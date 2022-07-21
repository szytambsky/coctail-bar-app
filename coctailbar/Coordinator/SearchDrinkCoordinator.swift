//
//  SearchDrinkCoordinator.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 20/07/2022.
//

import Foundation
import UIKit

final class SearchDrinkCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchDrinkViewController = SearchDrinkViewController()
        let drinkListViewModel = DrinkListViewModel(drinkApiService: DrinkApiService())
        drinkListViewModel.coordinator = self
        searchDrinkViewController.viewModel = drinkListViewModel
        navigationController.setViewControllers([searchDrinkViewController], animated: false)
    }
    
    func showDrinkDetailView(id: String) {
        let drinkDetailCoordinator = DrinkDetailCoordinator(navigationController: navigationController)
        drinkDetailCoordinator.parentCoordinator = self
        drinkDetailCoordinator.id = id
        childCoordinators.append(drinkDetailCoordinator)
        print("DEBUG: SearchDrinkCoordinator -> drinkDetailCoordinator.start()")
        drinkDetailCoordinator.start()
    }
    
    // Remove reference to child so it could be deallocated
    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
