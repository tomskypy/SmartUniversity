//
//  RoomsListViewController.swift
//  SmartUniversity
//
//  Created by Tomáš Skýpala on 07.04.2021.
//  Copyright © 2021 Tomas Skypala. All rights reserved.
//

import UIKit
import BaseAppCoordination

final class RoomsListViewController: BaseViewController<RoomsListScreenView> {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Room>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Room>

    enum Section: Hashable {
        case faculty(id: Int)
    }

    var didFinishHandler: (() -> Void)? // TODO add return navigation UI

    private var dataSource: DataSource?

    private let facultyRemoteDataProvider: FacultyRemoteDataProviding

    private static let facultyHeaderReuseIdentifier = "FacultyHeaderCell"
    private static let roomCellReuseIdentifier = "RoomDetailCell"

    init(facultyRemoteDataProvider: FacultyRemoteDataProviding) {
        self.facultyRemoteDataProvider = facultyRemoteDataProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRoomsCollectionView()
        refreshRoomsCollection(animated: false) // TODO handle loading
    }

    private func setupRoomsCollectionView() {
        guard let roomsCollectionView = screenView?.roomsCollectionView else {
            return
        }

        roomsCollectionView.register(
            ContainerCollectionViewCell<RoomDetailView>.self,
            forCellWithReuseIdentifier: Self.roomCellReuseIdentifier
        )
        roomsCollectionView.register(
            FacultyNameView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Self.facultyHeaderReuseIdentifier
        )

        dataSource = DataSource(
            collectionView: roomsCollectionView,
            cellProvider: { collectionView, indexPath, room in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: Self.roomCellReuseIdentifier,
                    for: indexPath
                )

                guard let roomDetailView = (cell as? ContainerCollectionViewCell<RoomDetailView>)?.containedView else {
                    return nil
                }

                roomDetailView.model = .init(
                    capacity: room.capacity,
                    isLocked: room.isLocked,
                    roomTypeText: room.roomTypeName,
                    buildingNameText: room.buildingName,
                    nameText: room.name,
                    descriptionText: room.description
                )
                return cell
            }
        )
        dataSource?.supplementaryViewProvider = { (collectionView, elementKind, path) -> UICollectionReusableView? in

            guard
                elementKind == UICollectionView.elementKindSectionHeader,
                let facultyNameView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: Self.facultyHeaderReuseIdentifier,
                    for: path
                ) as? FacultyNameView
            else {
                return nil
            }
            facultyNameView.label.text = "Faculty" // TODO use fetched data
            return facultyNameView
        }
    }

    private func refreshRoomsCollection(animated: Bool) {
        facultyRemoteDataProvider.getAllFaculties { [weak self] faculties, _ in

            guard let dataSource = self?.dataSource, let faculties = faculties else { return }

            var snapshot = Snapshot()
            snapshot.appendSections(faculties.map({ Section.faculty(id: $0.id) }))
            faculties.forEach { faculty in
                snapshot.appendItems(faculty.rooms, toSection: .faculty(id: faculty.id))
            }

            dataSource.apply(snapshot, animatingDifferences: animated)
        }
    }
}
