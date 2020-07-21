//
//  UILabel+Inits.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension UILabel {

    convenience init(
        text: String = "",
        font: UIFont,
        textColor: UIColor,
        textAlignment: NSTextAlignment = .natural,
        numberOfLines: Int = 1,
        adjustsFontSizeToFitWidth: Bool = false
    ) {
        self.init()

        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        if adjustsFontSizeToFitWidth {
            self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
            self.minimumScaleFactor = 0.5
        }
    }
}
