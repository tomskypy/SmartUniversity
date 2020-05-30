//
//  UILabel+Inits.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension UILabel {

    convenience init(font: UIFont, textColor: UIColor, numberOfLines: Int = 1) {
        self.init()

        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
}
