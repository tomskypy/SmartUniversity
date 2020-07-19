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

    private static let primaryColorSet = makeColorSet(lightColorHex: "#4f83cc", darkColorHex: "#69b6ff")
    private static let primaryDarkColorSet = makeColorSet(lightColorHex: "#3c5d8c", darkColorHex: "#000d34")

    private static let secondaryColorSet = makeColorSet(lightColorHex: "#62757f", darkColorHex: "#a6bfcc")

    private static let neutralColorSet = makeColorSet(lightColorHex: "#cfcfcf", darkColorHex: "#707070")
    private static let negativeColorSet = makeColorSet(lightColorHex: "#ff5131", darkColorHex: "#9b0000")

    private static let backgroundColorSet = ColorSet(light: .white, dark: .black)

    private static let textColorSet = ColorSet(light: .darkText, dark: .lightText)
    private static let ligthTextColorSet = ColorSet(light: .white, dark: .lightText)

    private static let buttonTextColorSet = ColorSet(light: .white, dark: .black)

    var primaryColor: UIColor {
        actualColor(for: Self.primaryColorSet)
    }

    var primaryDarkColor: UIColor {
        actualColor(for: Self.primaryDarkColorSet)
    }

    var secondaryColor: UIColor {
        actualColor(for: Self.secondaryColorSet)
    }

    var neutralColor: UIColor {
        actualColor(for: Self.neutralColorSet)
    }

    var negativeColor: UIColor {
        actualColor(for: Self.negativeColorSet)
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

    var lightTextColor: UIColor {
        actualColor(for: Self.ligthTextColorSet)
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

    private static func makeColorSet(lightColorHex: String, darkColorHex: String) -> ColorSet {

        guard let lightColor = UIColor(hex: lightColorHex), let darkColor = UIColor(hex: darkColorHex) else {
            fatalError("Failed to initiate UIColor from the provided HEX string.")
        }
        return ColorSet(light: lightColor, dark: darkColor)
    }
}
