//
//  AppColorProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class AppColorProvider: ColorProviding {

    static let shared = AppColorProvider()

    private struct ColorSet {
        let light: UIColor
        let dark: UIColor

        func reversed() -> ColorSet {
            .init(light: dark, dark: light)
        }
    }

    private static let primaryColorSet = ColorSet(light: UIColor(hex: "#005bb2")!, dark: UIColor(hex: "#69b6ff")!) // FIXME: get rid of !s
    private static let secondaryColorSet = ColorSet(light: UIColor(hex: "#4a626d")!, dark: UIColor(hex: "#a6bfcc")!)

    private static let backgroundColorSet = ColorSet(light: .white, dark: .black)
    private static let textColorSet = ColorSet(light: .darkText, dark: .lightText)
    private static let buttonTextColorSet = ColorSet(light: .white, dark: .black)

    var primaryColor: UIColor {
        actualColor(for: Self.primaryColorSet)
    }

    var secondaryColor: UIColor {
        actualColor(for: Self.secondaryColorSet)
    }

    var backgroundColor: UIColor {
        actualColor(for: Self.backgroundColorSet)
    }

    var overlayColor: UIColor {
        actualColor(for: Self.backgroundColorSet).withAlphaComponent(0.45)
    }

    var textColor: UIColor {
        actualColor(for: Self.textColorSet)
    }

    var buttonTextColor: UIColor {
        actualColor(for: Self.buttonTextColorSet)
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
