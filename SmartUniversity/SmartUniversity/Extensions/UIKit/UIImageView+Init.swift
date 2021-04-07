//
//  UIImageView+Init.swift
//  SmartUniversity
//
//  Created by Tomáš Skýpala on 07.04.2021.
//  Copyright © 2021 Tomas Skypala. All rights reserved.
//

import UIKit

extension UIImageView {

    convenience init(imageSystemName: String, tint: UIColor) {
        self.init()

        image = UIImage(systemName: imageSystemName)
        tintColor = tint
    }
}
