//
//  Appearance.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 19/07/2022.
//

import Foundation
import UIKit

class Appearance {
    static let drinkCellRadius: CGFloat = 8
    static let drinkCellPaddingBetween: CGFloat = 8
    static let drinkCellLabelPadding: CGFloat = 8
    
    static let drinkDetailViewPadding: CGFloat = 8
    static let drinkDetailContainerRadius: CGFloat = 8
    
    static let mainBackgroundColor: UIColor = UIColor(named: "mainBackground")!
}


// MARK: - CacheConfig

/// Fixed maximum allowed cost of memory and number of objects in NSCache.
struct CacheConfig {
    static let countLimit: Int = 100
    static let memoryLimit: Int = 1024 * 1024 * 100 // 100 MB
}
