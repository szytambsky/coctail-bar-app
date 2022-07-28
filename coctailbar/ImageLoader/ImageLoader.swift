//
//  ImageLoader.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 27/07/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class ImageLoader {
    // MARK: - TO DO: Eventually refactor to DI if needed
    ///  Shared instances leads to spaghetti code and conflicts when multiple objects interacting with the shared instance
    ///
    ///  We can use DI to manage who make changes, but for limited resource like cache it seems fine i guess to have access from anywhere.
    static let shared = ImageLoader()
    
    private var cache: ImageCacheProtocol
    private let drinkApiService: DrinkApiServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(cache: ImageCacheProtocol = ImageCache(), drinkApiService: DrinkApiServiceProtocol = DrinkApiService()) {
        self.cache = cache
        self.drinkApiService = drinkApiService
    }
    
    func rx_image(from url: URL) -> Driver<UIImage?> {
        return Observable<UIImage?>.create { [weak self] observer -> Disposable in
            if let image = self?.cache[url] {
                observer.onNext(image)
                observer.onCompleted()
            } else {
                self?.drinkApiService.fetchImageWith(url: url) { result in
                    switch result {
                    case .failure(let error):
                        print("DEBUG: \(error)")
                        //observer.onError(error)
                    case .success(let resultImage):
                        var image: UIImage?
                        image = resultImage
                        self?.cache[url] = image
                        observer.onNext(image)
                        observer.onCompleted()
                    }
                }
            }
            
            return Disposables.create {}
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asDriver(onErrorJustReturn: nil)
    }
}
