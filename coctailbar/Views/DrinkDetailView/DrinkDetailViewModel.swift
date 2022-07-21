//
//  DrinkDetailViewModel.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 20/07/2022.
//

import Foundation
import RxSwift

final class DrinkDetailViewModel {
    
    // MARK: - Properties
    private let drinkApiService: DrinkApiService
    private let baseUrl = "https://www.thecocktaildb.com/"
    var coordinator: DrinkDetailCoordinator?
    
    init(drinkApiService: DrinkApiService) {
        self.drinkApiService = drinkApiService
    }
    
    // MARK: - Coordinator related functions
    func viewDisappear() {
        coordinator?.didFinishDrinkDetailView()
    }
    
    // MARK: - Methods related to DetailApiService
    func getDrinkDetails(drinkId: String) -> Observable<DrinkDetailsResponse> {
        // MARK: - TO DO unwrap safely URL
        return drinkApiService.fetchDrinks(url: URL(string: baseUrl + "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(drinkId)")!)
    }
}
