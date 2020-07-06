//
//  UIButton+Inits.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension UIButton {

    enum Style {
        case transparent
        case solid(UIColor)
    }

    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { layer.cornerRadius }
    }

    convenience init(
        style: Style = .solid(.lightGray),
        titleText: String? = nil,
        cornerRadius: CGFloat = 6,
        colorProviding: ColorProviding? = nil
    ) {
        self.init(type: .system)
        if let titleText = titleText {
            setTitle(titleText, for: .normal)
            setTitleColor(style.titleColor(colorProviding: colorProviding), for: .normal)
        }
        self.backgroundColor = style.backgroundColor
        self.cornerRadius = cornerRadius
    }
}

private extension UIButton.Style {

    var backgroundColor: UIColor {
        switch self {
        case .solid(let color): return color
        case .transparent:      return .clear
        }
    }

    func titleColor(colorProviding: ColorProviding?) -> UIColor {
        switch self {
        case .solid:        return colorProviding?.buttonTextColor ?? .white
        case .transparent:  return colorProviding?.secondaryColor ?? .systemBlue
        }
    }
}
