//
//  RoomsListViewController+App.swift
//  SmartUniversity
//
//  Created by Tomáš Skýpala on 07.04.2021.
//  Copyright © 2021 Tomas Skypala. All rights reserved.
//

extension RoomsListViewController {

    convenience init() {
        self.init(facultyRemoteDataProvider: RemoteDataProvider.shared)
    }
}
