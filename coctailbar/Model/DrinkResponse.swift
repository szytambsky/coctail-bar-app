//
//  DrinkModel.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 19/07/2022.
//

import Foundation

// MARK: - GameModel
struct DrinkResponse: Codable {
    let drinks: [Drink]
}

// MARK: - Drink
struct Drink: Codable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
    
    private enum CodingKeys: String, CodingKey {
        case strDrink = "name"
        case strDrinkThumb = "thumbnailUrl"
        case idDrink
    }
}
