//
//  GradientView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 04/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class GradientView: UIView {

    enum Axis {
        case horizontal(locations: [NSNumber], leftToRight: Bool)
        case vertical(locations: [NSNumber], upToDown: Bool)
    }

    struct Configuration {
        let color: UIColor
        let axis: Axis

        var colors: [CGColor] {
            [UIColor.clear.cgColor, color.cgColor, color.cgColor]
        }

        init(color: UIColor, axis: Axis) {
            self.color = color
            self.axis = axis
        }
    }

    private var gradientLayer: CAGradientLayer {
        didSet { layer.mask = gradientLayer }
    }

    init(configuration: Configuration) {
        self.gradientLayer = Self.makeMaskingGradientLayer(with: configuration)
        super.init(frame: .zero)

        backgroundColor = configuration.color.withAlphaComponent(0.45)
        layer.mask = gradientLayer
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        gradientLayer.frame = bounds
    }

    private static func makeMaskingGradientLayer(with configuration: Configuration) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = configuration.axis.startPoint
        gradientLayer.endPoint = configuration.axis.endPoint
        gradientLayer.colors = configuration.colors
        gradientLayer.locations = configuration.axis.locations
        return gradientLayer
    }
}

private extension GradientView.Axis {

    var startPoint: CGPoint {

        switch self {
            case .horizontal(_, let leftToRight):  return makeMidpoint(at: leftToRight ? 0.0 : 1.0)
            case .vertical(_, let upToDown):       return makeMidpoint(at: upToDown ? 1.0 : 0.0)
        }
    }

    var endPoint: CGPoint {
        switch self {
            case .horizontal(_, let leftToRight):  return makeMidpoint(at: leftToRight ? 1.0 : 0.0)
            case .vertical(_, let upToDown):       return makeMidpoint(at: upToDown ? 0.0 : 1.0)
        }
    }

    var locations: [NSNumber] {
        switch self {
            case .horizontal(let locations, _):    return locations
            case .vertical(let locations, _):      return locations
        }
    }

    private func makeMidpoint(at value: CGFloat) -> CGPoint {
        switch self {
            case .horizontal:   return CGPoint(x: value, y: 0.5)
            case .vertical:     return CGPoint(x: 0.5, y: value)
        }
    }
}
