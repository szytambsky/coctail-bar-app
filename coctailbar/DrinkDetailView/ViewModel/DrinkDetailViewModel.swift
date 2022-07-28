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
    private let drinkApiService: DrinkApiServiceProtocol
    
    // MARK: - TO DO, On production we have to make a class that builds this url request for us in more composable way
    private let baseUrl = "https://www.thecocktaildb.com"
    var coordinator: DrinkDetailCoordinator?
    
    init(drinkApiService: DrinkApiServiceProtocol = DrinkApiService()) {
        self.drinkApiService = drinkApiService
    }
    
    // MARK: - Coordinator related functions
    func viewDisappear() {
        coordinator?.didFinishDrinkDetailView()
    }
    
    // MARK: - Methods related to DetailApiService
    func getDrinkDetails(drinkId: String) -> Observable<DrinkDetailMappedViewModel> {
        // MARK: - TO DO unwrap safely URL
        return drinkApiService.fetchDrinkDetailsResponse(url: URL(string: baseUrl + "/api/json/v1/1/lookup.php?i=\(drinkId)")!).map({ DrinkDetailMappedViewModel(drink: $0) })
    }
}
