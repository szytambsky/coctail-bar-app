//
//  SearchDrinkViewController.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 18/07/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SearchDrinkViewController: UIViewController {
    
    // MARK: - Properties
    private let drinkCellId = "drinkCellId"
    
    var viewModel: DrinkListViewModel!
    private let disposeBag = DisposeBag()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for coctail"
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Appearance.mainBackgroundColor
        cv.delegate = self
        cv.dataSource = nil
        cv.register(DrinkCell.self, forCellWithReuseIdentifier: drinkCellId)
        return cv
    }()
    

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bindCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - UI
    
    private func configureLayout() {
        view.backgroundColor = Appearance.mainBackgroundColor
        
        navigationItem.searchController = searchController
        navigationItem.title = "Coctail finder"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 16,
                              paddingBottom: 0,
                              paddingRight: 16)
    }
    
    // MARK: - Bind CollectionView
    func bindCollectionView() {
        searchController.searchBar.rx.text.asObservable()
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { ($0 ?? "").lowercased() }
            .filter { !$0.isEmpty }
            .flatMapLatest { [unowned self] term -> Observable<[DrinkMappedViewModel]> in
                return viewModel.getDrinkViewModelWithImage(drinkName: term)
            }
            .bind(to: collectionView.rx.items(cellIdentifier: drinkCellId, cellType: DrinkCell.self)) { [weak self]
                index, model, cell in
                
                cell.nameLabel.text = model.drinkName
                
                // MARK: - TO DO: Refactor nested subscribing
                guard let url = URL(string: model.drinkThumbnailUrlString) else { return }
                let uiImageDriver = ImageLoader.shared.rx_image(from: url)
                self?.handleDriver(uiImageDriver, cell: cell)
                
            }.disposed(by: disposeBag)
        
        collectionView.rx
            .modelAndIndexSelected(DrinkMappedViewModel.self)
            .subscribe(onNext: { (model, indexPath) in
                self.viewModel.pushDetailView(id: model.idDrink)
            }).disposed(by: disposeBag)
    }
    
    private func handleDriver(_ driver: Driver<UIImage?>, cell: DrinkCell) {
        driver.asObservable()
            .bind { image in
                guard let image = image else { return }
                cell.drinkImageView.image = image
            }.disposed(by: disposeBag)
    }
    
}

// MARK: - Reactive proxy zip
/// Function that makes an  zipping from events on UI rx  components
extension Reactive where Base: UICollectionView {
    public func modelAndIndexSelected<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
        ControlEvent(events: Observable.zip(
            self.modelSelected(modelType),
            self.itemSelected
        ))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchDrinkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 2) - Appearance.drinkCellPaddingBetween), height: 200)
    }
}
