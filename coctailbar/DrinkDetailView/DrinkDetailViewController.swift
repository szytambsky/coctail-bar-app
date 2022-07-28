//
//  DrinkDetailViewController.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 19/07/2022.
//

import UIKit
import RxSwift
import RxCocoa

class DrinkDetailViewController: UIViewController {

    // MARK: - Properties
    var viewModel: DrinkDetailViewModel!
    var id: String?
    
    private let disposeBag = DisposeBag()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample title for product"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var drinkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "sampleDrink")
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample instruction for product"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    private let topContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Appearance.drinkDetailContainerRadius
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: - UI Binding
    
    func drinkDetailsBinding() {
        guard let drinkId = id else { return }
        
        viewModel.getDrinkDetails(drinkId: drinkId)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] item in
                self.nameLabel.text = item.drinkName
                self.instructionLabel.text = item.drinkInstruction

                // MARK: - TO DO: Refactor nested subscribing
                guard let url = URL(string: item.drinkThumbnailUrlString) else { return }
                let uiImageDriver = ImageLoader.shared.rx_image(from: url)
                self.handleDriver(uiImageDriver)
                
            }).disposed(by: disposeBag)
    }
    
    private func handleDriver(_ driver: Driver<UIImage?>) {
        driver.asObservable()
            .bind { [weak self] image in
                guard let image = image else { return }
                self?.drinkImageView.image = image
            }.disposed(by: disposeBag)
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
        
        
        // MARK: - TO DO Dynamic height of parent view depends on child views
        view.addSubview(topContainer)
        topContainer.centerX(inView: self.view)
        topContainer.anchor(top: drinkImageView.bottomAnchor,
                            paddingTop: 4,
                            width: self.view.frame.width - Appearance.drinkDetailViewPadding,
                            height: 130)
        
        topContainer.addSubview(nameLabel)
        nameLabel.centerX(inView: self.view)
        nameLabel.anchor(top: topContainer.topAnchor,
                         paddingTop: 8,
                         width: self.view.frame.width - Appearance.drinkDetailViewPadding * 2)
        
        topContainer.addSubview(instructionLabel)
        instructionLabel.centerX(inView: self.view)
        instructionLabel.anchor(top: nameLabel.bottomAnchor,
                                paddingTop: 8,
                                width: self.view.frame.width - Appearance.drinkDetailViewPadding * 2)
        
    }
}
