//
//  DrinkApiService.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 19/07/2022.
//

import Foundation
import RxSwift

protocol DrinkApiServiceProtocol {
    func fetchDrinks<T>(url: URL) -> Observable<T>  where T : Decodable
    func fetchDrinkResponse(url: URL) -> Observable<[Drink]>
    func fetchDrinkDetailsResponse(url: URL) -> Observable<DrinkDetails>
}

// MARK: - DrinkApiServiceProtocol

final class DrinkApiService: DrinkApiServiceProtocol {
    
    func fetchDrinkResponse(url: URL) -> Observable<[Drink]> {
        return Observable.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                    return
                }
                
                do {
                    let drinkResponse = try JSONDecoder().decode(DrinkResponse.self, from: data)
                    
                    observer.onNext(drinkResponse.drinks)
                    observer.onCompleted()
                } catch(let error) {
                    // MARK: - TO DO: Handle returning Void - Lack of Results UI
                    print(error)
                    //observer.onError(error)
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func fetchDrinkDetailsResponse(url: URL) -> Observable<DrinkDetails> {
        return Observable.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                    return
                }
                
                do {
                    let drinkResponse = try JSONDecoder().decode(DrinkDetailsResponse.self, from: data)
                    print("DEBUG: decoded response name: \(String(describing: drinkResponse.drinks.first?.idDrink))")
                    observer.onNext(drinkResponse.drinks.first!)
                    observer.onCompleted()
                } catch(let error) {
                    // MARK: - TO DO: Handle returning Void - Lack of Results UI
                    print(error)
                    //observer.onError(error)
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

// MARK: - TO DO: Use Generic Instead
extension DrinkApiService {
    
    func fetchDrinks<T>(url: URL) -> Observable<T> where T: Decodable {
        return Observable.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                    return
                }
                
                do {
                    let drinks = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(drinks)
                    observer.onCompleted()
                } catch(let error) {
                    observer.onError(error)
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
