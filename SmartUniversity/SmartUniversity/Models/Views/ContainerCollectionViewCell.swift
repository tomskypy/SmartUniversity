//
//  ContainerCollectionViewCell.swift
//  SmartUniversity
//
//  Created by Tomáš Skýpala on 07.04.2021.
//  Copyright © 2021 Tomas Skypala. All rights reserved.
//

import UIKit

protocol ReusableView: UIView {

    init(frame: CGRect)

    func sizeThatFits(_ size: CGSize) -> CGSize

    func prepareForReuse()
}

final class ContainerCollectionViewCell<ContainedView: ReusableView>: UICollectionViewCell {

    let containedView = ContainedView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubviews(containedView)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containedView.frame = contentView.bounds
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        containedView.sizeThatFits(size)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        containedView.prepareForReuse()
    }
}
