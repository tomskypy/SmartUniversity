//
//  UIEdgeInsets+Sum.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    var horizontalSum: CGFloat {
        left + right
    }

    var verticalSum: CGFloat {
        top + bottom
    }
}
