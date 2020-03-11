//
//  UIView+Sizing.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension UIView {

    func size(constrainedToWidth width: CGFloat) -> CGSize {
        return self.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    }

    func height(constrainedToWidth width: CGFloat) -> CGFloat {
        return size(constrainedToWidth: width).height
    }
}
