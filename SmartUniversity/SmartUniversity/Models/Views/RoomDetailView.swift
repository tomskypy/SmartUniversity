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
        let roomTypeText: String
        let nameText: String
        let descriptionText: String
    }

    override var insets: UIEdgeInsets {
        .init(all: 10)
    }

    var model: Model? {
        didSet {
            guard let model = model else {
                prepareForReuse()
                return
            }

            roomTypeLabel.text = model.roomTypeText
            nameLabel.text = model.nameText
            descriptionLabel.text = model.descriptionText

            setNeedsLayout()
        }
    }

    private let roomTypeLabel = UILabel(font: UIFont.systemFont(ofSize: 10, weight: .semibold), textColor: .darkGray)
    private let nameLabel = UILabel(font: UIFont.systemFont(ofSize: 20, weight: .medium), textColor: .black)
    private let descriptionLabel = UILabel(
        font: UIFont.systemFont(ofSize: 12),
        textColor: .black,
        numberOfLines: 0
    )

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 6
        backgroundColor = UIColor(red: 155/255, green: 231/255, blue: 255/255, alpha: 1)

        addSubviews(roomTypeLabel, nameLabel, descriptionLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {

        let contentWidth = width - insets.horizontalSum
        let verticalSpacing: CGFloat = 4

        let roomTypeFrame = CGRect(
            x: insets.left,
            y: insets.top,
            size: roomTypeLabel.size(constrainedToWidth: contentWidth)
        )

        let nameFrame = CGRect(
            x: insets.left,
            y: roomTypeFrame.maxY + verticalSpacing,
            size: nameLabel.size(constrainedToWidth: contentWidth)
        )

        let descriptionFrame = CGRect(
            x: insets.left,
            y: nameFrame.maxY + verticalSpacing,
            size: descriptionLabel.size(constrainedToWidth: contentWidth)
        )

        return super.frames(forWidth: width)
            + [(roomTypeLabel, roomTypeFrame), (nameLabel, nameFrame), (descriptionLabel, descriptionFrame)]
    }
}

extension RoomDetailView: ReusableView {

    func prepareForReuse() {
//        nameLabel.text = "" // TODO implement proper reuse preparation if needed
    }
}
