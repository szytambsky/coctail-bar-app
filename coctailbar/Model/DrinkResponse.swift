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
    let idDrink: String
    let name: String
    let thumbnailUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case idDrink
        case name = "strDrink"
        case thumbnailUrl = "strDrinkThumb"
    }
}

// MARK: - DrinkDetailsResponse
struct DrinkDetailsResponse: Codable {
    let drinks: [DrinkDetails]
}

// MARK: - DrinkDetails
struct DrinkDetails: Codable {
    let idDrink: String
    let name: String
    let thumbnailUrl: String
    let glass: String
    let strAlcoholic: String
    let strInstructions: String
    
    private enum CodingKeys: String, CodingKey {
        case idDrink, strAlcoholic, strInstructions
        case name = "strDrink"
        case thumbnailUrl = "strDrinkThumb"
        case glass = "strGlass"
    }
}
