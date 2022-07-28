//
//  DrinkViewModel.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 20/07/2022.
//

import Foundation

final class DrinkMappedViewModel {
    private var drink: Drink
    
    init(drink: Drink) {
        self.drink = drink
    }
    
    var drinkName: String {
        return drink.name
    }
    
    var idDrink: String {
        return drink.idDrink
    }
    
    var drinkThumbnailUrlString: String {
        return drink.thumbnailUrl
    }
}


