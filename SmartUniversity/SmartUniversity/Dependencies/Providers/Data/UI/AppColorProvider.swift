//
//  AppColorProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol ColorProviding {

    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
}

struct AppColorProvider: ColorProviding {

    static let shared = AppColorProvider()

    private struct ColorSet {
        let light: UIColor
        let dark: UIColor
    }

    private static let backgroundColorSet = ColorSet(light: .white, dark: .black)
    private static let textColorSet = ColorSet(light: .black, dark: .white)

    var backgroundColor: UIColor {
        actualColor(for: Self.backgroundColorSet)
    }

    var textColor: UIColor {
        actualColor(for: Self.textColorSet)
    }

    private init() { }

    private func actualColor(for colorSet: ColorSet) -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                // Return the color for Dark Mode
                return colorSet.dark
            } else {
                // Return the color for Light Mode
                return colorSet.light
            }
        }
    }
}
