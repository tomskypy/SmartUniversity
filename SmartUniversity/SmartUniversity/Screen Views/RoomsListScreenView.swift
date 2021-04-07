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

    let roomsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())

    private let titleLabel = UILabel(
        text: "Rooms",
        font: UIFont.systemFont(ofSize: 30, weight: .bold),
        textColor: .black
    )

    private let layoutProvider: LayoutProviding

    init(layoutProvider: LayoutProviding) {
        self.layoutProvider = layoutProvider
        super.init(frame: .zero)

        backgroundColor = .white
        roomsCollectionView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func frames(forBounds bounds: CGRect) -> [(view: UIView, frame: CGRect)] {

        let safeAreaInsets = layoutProvider.contentInsets(for: self, respectingSafeAreasOn: .all())

        let titleInsets = UIEdgeInsets(horizontal: 15, vertical: 20)

        let titleFrame = CGRect(
            x: safeAreaInsets.left + titleInsets.left,
            y: safeAreaInsets.top + titleInsets.top,
            size: titleLabel.size(
                constrainedToWidth: bounds.width - (safeAreaInsets.horizontalSum + titleInsets.horizontalSum)
            )
        )
        let roomsCollectionYOffset = titleFrame.maxY + titleInsets.bottom
        let roomsCollectionSize = CGSize(
            width: bounds.width,
            height: bounds.height - roomsCollectionYOffset
        )
        let roomsCollectionFrame = CGRect(x: 0, y: roomsCollectionYOffset, size: roomsCollectionSize)

        return super.frames(forBounds: bounds) + [(titleLabel, titleFrame), (roomsCollectionView, roomsCollectionFrame)]
    }

    private static func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let cellSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let section = NSCollectionLayoutSection(
            group: .horizontal(layoutSize: cellSize, subitem: .init(layoutSize: cellSize), count: 1)
        )
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]

        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension RoomsListScreenView: BaseScreenView {

    func setupSubviews() {
        addSubviews(titleLabel, roomsCollectionView)
    }
}
