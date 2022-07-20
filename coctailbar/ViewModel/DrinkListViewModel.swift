//
//  DrinkListViewModel.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 19/07/2022.
//

import Foundation
import RxSwift

final class DrinkListViewModel {
    
    private let drinkApiService: DrinkApiServiceProtocol
    // MARK: - TO DO, On production we have to have a class that builds this url request for us in more composable way
    private let baseUrl = "https://www.thecocktaildb.com/"
    
    init(drinkApiService: DrinkApiServiceProtocol = DrinkApiService()) {
        self.drinkApiService = drinkApiService
    }
    
    // MARK: - detailed array from another observable of array
    func getDrinkResponseViewModels(drinkName: String) -> Observable<DrinkResponse> {
        // MARK: - TO DO unwrap safely URL
        return drinkApiService.fetchDrinks(url: URL(string: baseUrl + "/api/json/v1/1/filter.php?i=\(drinkName)")!)
    }
    
    func getDrinkViewModel(drinkName: String) -> Observable<[Drink]> {
        // MARK: - TO DO unwrap safely URL
        return drinkApiService.fetchDrinkResponse(url: URL(string: baseUrl + "/api/json/v1/1/filter.php?i=\(drinkName)")!)
    }
    
    func getDrinkDetails(drinkId: String) -> Observable<DrinkDetailsResponse> {
        // MARK: - TO DO unwrap safely URL
        return drinkApiService.fetchDrinks(url: URL(string: baseUrl + "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(drinkId)")!)
    }
    
}