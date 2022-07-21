//
//  DrinkDetailMappedViewModel.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 21/07/2022.
//

import Foundation

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
    
    // F.g. Kingfisher, Nuke or SDWebImage instead
    func setImageWithUrl() -> Data? {
        let url = URL(string: drink.thumbnailUrl)
        let data = try? Data(contentsOf: url!)
        return data
    }
}
