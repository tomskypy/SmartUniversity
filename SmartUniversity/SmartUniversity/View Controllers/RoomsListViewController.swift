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

    private static let roomCellIdentifier = "RoomListCell"

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
            forCellWithReuseIdentifier: Self.roomCellIdentifier
        )

        dataSource = DataSource(
            collectionView: roomsCollectionView,
            cellProvider: { collectionView, indexPath, room in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: Self.roomCellIdentifier,
                    for: indexPath
                )

                guard let roomDetailView = (cell as? ContainerCollectionViewCell<RoomDetailView>)?.containedView else {
                    return nil
                }

                roomDetailView.model = .init(
                    roomTypeText: room.roomTypeName,
                    nameText: room.name,
                    descriptionText: room.description
                )
                return cell
            }
        )

        if let flowLayout = roomsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        roomsCollectionView.delegate = self
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

extension RoomsListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        .init(width: collectionView.frame.width - 10, height: 0)
    }
}
