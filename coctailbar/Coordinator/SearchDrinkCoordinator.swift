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
        
        // Set root ViewController in our navigationController
        navigationController.setViewControllers([searchDrinkViewController], animated: false)
    }
    
    
}
