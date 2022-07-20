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
}

// MARK: - DrinkApiServiceProtocol

final class DrinkApiService: DrinkApiServiceProtocol {
    
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
                    // MARK: - TO DO delete or stay here
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
                    // MARK: - TO DO: Handle returning Void on completion from blank response f.e NoResultsView
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
