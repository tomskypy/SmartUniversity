//
//  ARScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class ARScreenView: FrameBasedView {

    override var margins: UIEdgeInsets { UIEdgeInsets(all: 50) }

    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, Smart University developer!"
        label.textColor = .green

        return label
    }()

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {

        let availableWidth = width - margins.left - margins.right

        let labelFrame =  CGRect(
            x: margins.top,
            y: margins.left,
            width: availableWidth,
            height: testLabel.height(constrainedToWidth: availableWidth)
        )

        return [(view: testLabel, frame: labelFrame)]
    }
}

extension ARScreenView: BaseScreenView {

    func setupSubviews() {
        backgroundColor = .black

        addSubview(testLabel)
    }
}
