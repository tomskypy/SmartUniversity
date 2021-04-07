//
//  RoomDetailView.swift
//  SmartUniversity
//
//  Created by Tomáš Skýpala on 07.04.2021.
//  Copyright © 2021 Tomas Skypala. All rights reserved.
//

import UIKit

final class RoomDetailView: VerticalFrameBasedView {

    struct Model {
        let nameText: String
    }

    var model: Model? {
        didSet {
            guard let model = model else {
                prepareForReuse()
                return
            }

            nameLabel.text = model.nameText

            setNeedsLayout()
        }
    }

    private let nameLabel = UILabel(font: UIFont.systemFont(ofSize: 20, weight: .medium), textColor: .black)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(nameLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {

        let contentWidth = width - insets.horizontalSum
        let nameLabelSize = nameLabel.size(constrainedToWidth: contentWidth)

        return super.frames(forWidth: width) + [(nameLabel, CGRect(x: insets.left, y: insets.top, size: nameLabelSize))]
    }
}

extension RoomDetailView: ReusableView {

    func prepareForReuse() {
//        nameLabel.text = "" // TODO implement proper reuse preparation if needed
    }
}
