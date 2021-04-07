//
//  MainNavigationCoordinator+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit
import BaseAppCoordination

extension MainNavigationCoordinator {

    convenience init(navigationController: NavigationController) {
        self.init(
            navigationController: navigationController,
            dependencies: .init(
                viewControllerFactory: AppMainNavigationViewControllerFactory(),
                appConfigurationProvider: AppConfigurationProvider()
            )
        )
    }
}

struct AppMainNavigationViewControllerFactory: MainNavigationViewControllerFactory {

    func makeViewController(for scene: MainNavigationScene) -> UIViewController {
        switch scene {
            case .qrScanner(let delegate):
                return QRScannerViewController(delegate: delegate)
            case .munimap(let focusedPlaceID):
                return MunimapViewController(focusedPlaceID: focusedPlaceID)
            case .arView(let roomsData):
                return ARViewController(roomsData: roomsData)
        }
    }
}

private extension QRScannerViewController {

    convenience init(delegate: QRScannerViewControllerDelegate) {
        self.init()

        self.delegate = delegate
    }
}
