//
//  RoomsListScreenView.swift
//  SmartUniversity
//
//  Created by Tomáš Skýpala on 07.04.2021.
//  Copyright © 2021 Tomas Skypala. All rights reserved.
//

import UIKit
import BaseAppCoordination

final class RoomsListScreenView: FrameBasedView {

    let roomsCollectionView = UICollectionView(
        frame: .init(origin: .zero, size: CGSize(width: 300, height: 200)), // TODO fix collection view sizing/layout
        collectionViewLayout: .init()
    )

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .yellow
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {

        let collectionViewTopSpacing: CGFloat = 100
        let roomsCollectionSize = roomsCollectionView.sizeThatFits(
            .init(width: bounds.width, height: bounds.height - collectionViewTopSpacing)
        )

        let roomsCollectionFrame = CGRect(x: 0, y: collectionViewTopSpacing, size: roomsCollectionSize)

        return super.frames(forBounds: bounds) + [(roomsCollectionView, roomsCollectionFrame)]
    }
}

extension RoomsListScreenView: BaseScreenView {

    func setupSubviews() {
        addSubview(roomsCollectionView)
    }
}
