//
//  UIView+subviews.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 09/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension UIView {

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
