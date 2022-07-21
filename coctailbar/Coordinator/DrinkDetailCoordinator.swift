//
//  DrinkDetailCoordinator.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 20/07/2022.
//

import Foundation
import UIKit

final class DrinkDetailCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    var parentCoordinator: SearchDrinkCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let drinkDetailViewController = DrinkDetailViewController()
        let drinkDetailViewModel = DrinkDetailViewModel(drinkApiService: DrinkApiService())
        drinkDetailViewModel.coordinator = self
        drinkDetailViewController.viewModel = drinkDetailViewModel
        print("DEBUG: DrinkDetailCoordinator -> navigationController.pushVC()")
        navigationController.pushViewController(drinkDetailViewController, animated: true)
    }
 
    func didFinishDrinkDetailView() {
        parentCoordinator?.childDidFinish(self)
    }
    
    deinit {
        print("DEBUG: deinit from SearchDrinkCoordinator ")
    }
}
