//
//  DrinkListViewModel.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 19/07/2022.
//

import Foundation
import RxSwift

final class DrinkListViewModel {
    
    // MARK: - Properties
    private let drinkApiService: DrinkApiServiceProtocol
    
    // MARK: - TO DO, On production we have to make a class that builds this url request for us in more composable way
    private let baseUrl = "https://www.thecocktaildb.com"
    var coordinator: SearchDrinkCoordinator?
    
    init(drinkApiService: DrinkApiServiceProtocol = DrinkApiService()) {
        self.drinkApiService = drinkApiService
    }
    
    // MARK: - Coordinator related functions
    func pushDetailView(id: String) {
        print("DEBUG: DrinkListViewModel -> SearchDrinkCoordinator?.showDrinkDetailView()")
        coordinator?.showDrinkDetailView(id: id)
    }
    
    // MARK: - Methods related to DetailApiService
    func getDrinkViewModelWithImage(drinkName: String) -> Observable<[DrinkMappedViewModel]> {
        // MARK: - TO DO unwrap safely URL
        return drinkApiService.fetchDrinkResponse(url: URL(string: baseUrl + "/api/json/v1/1/filter.php?i=\(drinkName)")!).map({ $0.map { DrinkMappedViewModel(drink: $0) } })
    }
}
