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
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Faculty>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Faculty>

    enum Section {
        case faculty
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refreshRoomsCollection(animated: false)
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
            cellProvider: { collectionView, indexPath, faculty in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: Self.roomCellIdentifier,
                    for: indexPath
                )

                guard let roomDetailView = (cell as? ContainerCollectionViewCell<RoomDetailView>)?.containedView else {
                    return nil
                }

                roomDetailView.model = .init(nameText: "configured name") // TODO use faculty data
                return cell
            }
        )
    }

    private func refreshRoomsCollection(animated: Bool) {
        facultyRemoteDataProvider.getAllFaculties { [weak self] faculties, _ in

            guard let self = self, let faculties = faculties else { return }

            var snapshot = Snapshot()
            snapshot.appendSections([.faculty])
            snapshot.appendItems(faculties)

            self.dataSource?.apply(snapshot, animatingDifferences: animated)
        }

    }
}
