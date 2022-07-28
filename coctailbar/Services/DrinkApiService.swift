//
//  DrinkApiService.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 19/07/2022.
//

import Foundation
import RxSwift
import UIKit

protocol DrinkApiServiceProtocol {
    func fetchDrinks<T>(url: URL) -> Observable<T>  where T : Decodable
    func fetchDrinkResponse(url: URL) -> Observable<[Drink]>
    func fetchDrinkDetailsResponse(url: URL) -> Observable<DrinkDetails>
    
    func fetchImageWith(url: URL?, completion: @escaping (Result<UIImage?, APIError>) -> Void)
    func fetchImageWithRx(url: URL) -> Observable<UIImage?>
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

// MARK: - Fetching image with URL

extension DrinkApiService {
    func fetchImageWith(url: URL?, completion: @escaping (Result<UIImage?, APIError>) -> Void) {
        guard let url = url else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error as? URLError {
                completion(Result.failure(.url(error)))
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                let err = APIError.badResponse(statusCode: response.statusCode)
                completion(Result.failure(err))
            } else if let data = data {
                let image = UIImage(data: data)
                completion(Result.success(image))
            }

        }
        
        task.resume()
    }
    
    // MARK: - Second option but i have not explored rxswift enough yet, how to avoid nesting subscribing (in ImageLoader rx_image func) to pass Driver from Observable in Observable.create with flatMap that cant infer type of closure parameter
    func fetchImageWithRx(url: URL) -> Observable<UIImage?> {
        return Observable<UIImage?>.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else {
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                
                let image = UIImage(data: data)
                observer.onNext(image)
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

