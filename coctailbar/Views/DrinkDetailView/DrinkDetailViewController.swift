//
//  DrinkDetailViewController.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 19/07/2022.
//

import UIKit

class DrinkDetailViewController: UIViewController {

    // MARK: - Properties
    var viewModel: DrinkDetailViewModel!
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample title for product"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        //label.backgroundColor = .green
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private let drinkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "sampleDrink")
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewModel = DrinkDetailViewModel(drinkApiService: DrinkApiService())
        configureUI()
        drinkDetailsBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDisappear()
    }

    // MARK: - UI
    func configureUI() {
        view.backgroundColor = Appearance.mainBackgroundColor
        
        view.addSubview(drinkImageView)
        drinkImageView.centerX(inView: self.view)
        drinkImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingLeft: 0,
                              paddingRight: 0,
                              height: 250)
        
        view.addSubview(nameLabel)
        nameLabel.centerX(inView: self.view)
        nameLabel.anchor(top: drinkImageView.bottomAnchor,
                         paddingTop: 4,
                         width: self.view.frame.width - Appearance.drinkCellLabelPadding)
    }
    
    // MARK: - Binding
    
    func drinkDetailsBinding() {
        
    }
}
