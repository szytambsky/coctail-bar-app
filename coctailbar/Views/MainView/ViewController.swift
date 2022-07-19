//
//  ViewController.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 18/07/2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let drinkCellId = "drinkCellId"
    
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
        cv.dataSource = self
        cv.register(DrinkCell.self, forCellWithReuseIdentifier: drinkCellId)
        return cv
    }()
    

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - UI
    private func configureProperties() {
    }
    
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
    
    // MARK: - Services
    
}


// MARK: -UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drinkDetailViewController = DrinkDetailViewController()
        navigationController?.pushViewController(drinkDetailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: drinkCellId, for: indexPath) as! DrinkCell
        //cell.backgroundColor = .red
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 2) - Appearance.drinkCellPaddingBetween), height: 200)
    }
}
