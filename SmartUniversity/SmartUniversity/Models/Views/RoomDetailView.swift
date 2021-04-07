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
        let buildingNameText: String
        let nameText: String
        let descriptionText: String

        fileprivate let attributeDetailModel: RoomAttributeDetailView.Model

        init(
            capacity: Int,
            isLocked: Bool,
            roomTypeText: String,
            buildingNameText: String,
            nameText: String,
            descriptionText: String
        ) {
            attributeDetailModel = .init(capacity: capacity, isLocked: isLocked)
            self.roomTypeText = roomTypeText
            self.buildingNameText = buildingNameText
            self.nameText = nameText
            self.descriptionText = descriptionText
        }
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

            attributeDetailView.model = model.attributeDetailModel

            roomTypeLabel.text = model.roomTypeText
            nameLabel.text = "\(model.buildingNameText) - \(model.nameText)"
            descriptionLabel.text = model.descriptionText

            setNeedsLayout()
        }
    }

    // MARK: - Views

    private let attributeDetailView = RoomAttributeDetailView()

    private let roomTypeLabel = UILabel(font: UIFont.systemFont(ofSize: 10, weight: .semibold), textColor: .darkGray)
    private let nameLabel = UILabel(font: UIFont.systemFont(ofSize: 20, weight: .bold), textColor: .black)
    private let descriptionLabel = UILabel(font: UIFont.systemFont(ofSize: 12), textColor: .black, numberOfLines: 0)

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 6
        backgroundColor = UIColor(red: 187/255, green: 222/255, blue: 251/255, alpha: 0.8)

        addSubviews(roomTypeLabel, nameLabel, descriptionLabel, attributeDetailView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layouting

    override func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {

        let verticalSpacing: CGFloat = 4
        let horizontalSpacing: CGFloat = 12

        let attributeDetailSize = attributeDetailView.size(constrainedToWidth: width / 2)
        let attributeDetailFrame = CGRect(
            x: width - (insets.right + attributeDetailSize.width),
            y: insets.top,
            size: attributeDetailSize
        )

        let titleMaxWidth = width - (insets.left + horizontalSpacing + attributeDetailFrame.minX)

        let roomTypeFrame = CGRect(
            x: insets.left,
            y: insets.top,
            size: roomTypeLabel.size(constrainedToWidth: titleMaxWidth)
        )

        let nameFrame = CGRect(
            x: insets.left,
            y: roomTypeFrame.maxY + verticalSpacing,
            size: nameLabel.size(constrainedToWidth: titleMaxWidth)
        )

        let descriptionFrame = CGRect(
            x: insets.left,
            y: nameFrame.maxY + verticalSpacing,
            size: descriptionLabel.size(constrainedToWidth: width - insets.horizontalSum)
        )

        return super.frames(forWidth: width)
            + [
                (attributeDetailView, attributeDetailFrame),
                (roomTypeLabel, roomTypeFrame),
                (nameLabel, nameFrame),
                (descriptionLabel, descriptionFrame)
            ]
    }
}

extension RoomDetailView: ReusableView {

    func prepareForReuse() {
        roomTypeLabel.text = ""
        nameLabel.text = ""
        descriptionLabel.text = ""
        attributeDetailView.model = nil
    }
}

private final class RoomAttributeDetailView: FrameBasedView {

    struct Model {
        let capacity: Int
        let isLocked: Bool
    }

    var model: Model? {
        didSet {
            guard let model = model else {
                prepareForReuse()
                return
            }

            capacityLabel.text = "\(model.capacity)"

            lockImageView.image = UIImage(systemName: model.lockImageSystemName)
            lockImageView.tintColor = model.lockImageTint
        }
    }

    // MARK: - Views

    private let lockImageView = UIImageView()

    private let capacityImageView = UIImageView(image: UIImage(systemName: "person"))
    private let capacityLabel = UILabel(font: UIFont.systemFont(ofSize: 12), textColor: .black)

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)

        capacityImageView.tintColor = .black

        addSubviews(lockImageView, capacityImageView, capacityLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layouting

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let currentFrames = frames(forWidth: size.width)
        let bottomMostFrame = currentFrames.max(by: { $0.frame.maxY < $1.frame.maxY })?.frame ?? .zero
        let rightMostFrame = currentFrames.max(by: { $0.frame.maxX < $1.frame.maxX })?.frame ?? .zero
        return CGSize(width: rightMostFrame.maxX, height: bottomMostFrame.maxY)
    }

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {
        frames(forWidth: bounds.width)
    }

    private func frames(forWidth width: CGFloat) -> [(view: UIView, frame: CGRect)] {

        let horizontalSpacing: CGFloat = 12
        let capacityIconLabelSpacing: CGFloat = 4

        let capacityImageSize = capacityImageView.size(constrainedToWidth: 20)
        let capacityLabelSize = capacityLabel.size(constrainedToWidth: 50)
        let lockImageSize = lockImageView.size(constrainedToWidth: 20)
        let height = max(capacityImageSize.height, capacityLabelSize.height, lockImageSize.height)

        let capacityLabelFrame = CGRect(
            x: bounds.width - capacityLabelSize.width,
            y: (height - capacityLabelSize.height) / 2,
            size: capacityLabelSize
        )

        let capacityImageFrame = CGRect(
            x: capacityLabelFrame.minX - (capacityIconLabelSpacing + capacityImageSize.width),
            y: (height - capacityImageSize.height) / 2,
            size: capacityImageSize
        )

        let lockImageFrame = CGRect(
            x: capacityImageFrame.minX - (horizontalSpacing + lockImageSize.width),
            y: (height - lockImageSize.height) / 2,
            size: lockImageSize
        )

        return super.frames(forBounds: bounds)
            + [
                (capacityImageView, capacityImageFrame),
                (capacityLabel, capacityLabelFrame),
                (lockImageView, lockImageFrame)
            ]
    }

    // MARK: - Reuse helper

    private func prepareForReuse() {
        capacityLabel.text = ""
        lockImageView.image = nil
    }
}

private extension RoomAttributeDetailView.Model {

    var lockImageSystemName: String {
        isLocked ? "lock.fill" : "lock.open"
    }

    var lockImageTint: UIColor {
        isLocked ? .systemRed : .systemGreen
    }
}
