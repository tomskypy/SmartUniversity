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
        case vertical
        case horizontal
    }

    struct Configuration {
        let locations: [NSNumber]
        let color: UIColor
        let axis: Axis

        var colors: [CGColor] {
            [UIColor.clear.cgColor, color.cgColor, color.cgColor]
        }
    }

    var configuration: Configuration {
        didSet { gradientLayer = Self.makeGradientLayer(with: configuration) }
    }

    private var gradientLayer: CAGradientLayer {
        willSet { gradientLayer.removeFromSuperlayer() }
        didSet { layer.mask = gradientLayer }
    }

    init(configuration: Configuration) {
        self.configuration = configuration
        self.gradientLayer = Self.makeGradientLayer(with: configuration)
        super.init(frame: .zero)

        backgroundColor = configuration.color.withAlphaComponent(0.45)
        layer.mask = gradientLayer
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        gradientLayer.frame = bounds
    }

    private static func makeGradientLayer(with configuration: Configuration) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = configuration.axis.startPoint
        gradientLayer.endPoint = configuration.axis.endPoint
        gradientLayer.colors = configuration.colors
        gradientLayer.locations = configuration.locations
        return gradientLayer
    }
}

private extension GradientView.Axis {

    var startPoint: CGPoint {
        switch self {
        case .horizontal: return CGPoint(x: 0, y: 0.5)
        case .vertical: return CGPoint(x: 0.5, y: 0)
        }
    }

    var endPoint: CGPoint {
        switch self {
        case .horizontal: return CGPoint(x: 1, y: 0.5)
        case .vertical: return CGPoint(x: 0.5, y: 1)
        }
    }
}
