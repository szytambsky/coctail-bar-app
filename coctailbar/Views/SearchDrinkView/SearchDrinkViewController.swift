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
    
    private var viewModel: DrinkListViewModel!
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
        viewModel = DrinkListViewModel(drinkApiService: DrinkApiService())
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
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { ($0 ?? "").lowercased() }
            .filter { !$0.isEmpty }
            .flatMapLatest { [unowned self] term -> Observable<[DrinkViewModel]> in
                return viewModel.getDrinkViewModelWithImage(drinkName: term)
            }
            .bind(to: collectionView.rx.items(cellIdentifier: drinkCellId, cellType: DrinkCell.self)) {
                index, model, cell in
                cell.nameLabel.text = model.drinkName
                if let imageData = model.setImageWithUrl() {
                    cell.drinkImageView.image = UIImage(data: imageData)
                }
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            print(indexPath.row)
            let drinkDetailViewController = DrinkDetailViewController()
            self?.navigationController?.pushViewController(drinkDetailViewController, animated: true)
        }).disposed(by: disposeBag)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchDrinkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 2) - Appearance.drinkCellPaddingBetween), height: 200)
    }
}
