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

    var didFinishHandler: (() -> Void)?

    private var dataSource: DataSource?

    private var faculties: [Faculty] = [] {
        didSet {
            updateDataSource()
        }
    }

    private let facultyRemoteDataProvider: FacultyRemoteDataProviding

    private static let facultyHeaderReuseIdentifier = "FacultyHeaderCell"
    private static let roomCellReuseIdentifier = "RoomDetailCell"

    init(facultyRemoteDataProvider: FacultyRemoteDataProviding) {
        self.facultyRemoteDataProvider = facultyRemoteDataProvider
        super.init(nibName: nil, bundle: nil)

        refreshFacultiesData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        screenView?.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        screenView?.refreshControl.addTarget(self, action: #selector(refreshFacultiesData), for: .valueChanged)

        setupRoomsCollectionView()
        if faculties.isEmpty {
            screenView?.refreshControl.beginRefreshing()
        } else {
            updateDataSource()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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

                roomDetailView.model = .init(room: room)
                return cell
            }
        )

        dataSource?.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, path) -> UICollectionReusableView? in

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
            facultyNameView.label.text = self.faculties[safe: path.section]?.name

            return facultyNameView
        }
    }

    @objc
    private func refreshFacultiesData() {
        facultyRemoteDataProvider.getAllFaculties { [weak self] faculties, error in

            DispatchQueue.main.async {
                guard let self = self else { return }
                self.screenView?.refreshControl.endRefreshing()

                if let error = error {
                    switch error {
                        case .fetch(let error): self.handleFetchError(error: error)
                    }
                } else if let faculties = faculties {
                    self.faculties = faculties
                }
            }
        }
    }

    @objc
    private func backButtonTapped() {
        self.didFinishHandler?()
    }

    private func updateDataSource() {
        guard let dataSource = dataSource else { return }

        var snapshot = Snapshot()
        snapshot.appendSections(faculties.map({ Section.faculty(id: $0.id) }))
        faculties.forEach { faculty in
            snapshot.appendItems(faculty.rooms, toSection: .faculty(id: faculty.id))
        }

        let isViewVisible = viewIfLoaded?.window != nil
        dataSource.apply(snapshot, animatingDifferences: isViewVisible)
    }

    private func handleFetchError(error: DataFetchError) {
        let alertTitle: String
        let alertMessage: String

        switch error {
            case .networkError:
                alertTitle = "Offline"
                alertMessage = "The internet connection is required to display rooms."
            case .invalidURLString, .parsingError:
                alertTitle = "Something Went Wrong"
                alertMessage = "Unexpected application error occured, press Ok to go back."
            case .noData:
                alertTitle = "No Data"
                alertMessage = "There is no rooms data available, press Ok to go back."
        }

        presentCriticalErrorAlertDialog(titleText: alertTitle, messageText: alertMessage)
    }

    private func presentCriticalErrorAlertDialog(titleText: String, messageText: String) {
        let alert = UIAlertController(
            title: titleText,
            message: messageText,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .default) { [unowned self] _ in
            self.didFinishHandler?()
        })

        present(alert, animated: true)
    }
}

private extension RoomDetailView.Model {

    init(room: Room) {
        self.init(
            capacity: room.capacity,
            isLocked: room.isLocked,
            roomTypeText: room.roomTypeName,
            buildingNameText: room.buildingName,
            nameText: room.name,
            descriptionText: room.description
        )
    }
}
