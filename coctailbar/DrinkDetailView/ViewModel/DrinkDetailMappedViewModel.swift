//
//  DrinkDetailMappedViewModel.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 21/07/2022.
//

import Foundation
import UIKit

final class DrinkDetailMappedViewModel {
    private var drink: DrinkDetails
    
    init(drink: DrinkDetails) {
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
    
    var drinkInstruction: String {
        return drink.strInstructions
    }
}
