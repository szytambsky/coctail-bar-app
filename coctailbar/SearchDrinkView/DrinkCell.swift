//
//  DrinkCell.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 19/07/2022.
//

import UIKit

class DrinkCell: UICollectionViewCell {
    
    // MARK: - Properties
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample title for product"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        //label.backgroundColor = .green
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    let drinkImageView: UIImageView = {
        let iv = UIImageView()
        //iv.image = UIImage(named: "sampleDrink")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = Appearance.drinkCellRadius / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func configureUI() {
        layer.cornerRadius = Appearance.drinkCellRadius
        backgroundColor = UIColor.white
        
        addSubview(drinkImageView)
        drinkImageView.centerX(inView: self)
        drinkImageView.anchor(left: leftAnchor,
                              right: rightAnchor,
                              paddingLeft: 0,
                              paddingRight: 0,
                              height: 150)
        
        addSubview(nameLabel)
        nameLabel.centerX(inView: self)
        nameLabel.anchor(top: drinkImageView.bottomAnchor,
                         paddingTop: 4,
                         width: self.frame.width - Appearance.drinkCellLabelPadding)
    }
    
}
