//
//  MainNavigationCoordinator+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension MainNavigationCoordinator {

    convenience init(navigationController: NavigationController) {
        self.init(
            navigationController: navigationController,
            dependencies: .init(viewControllerFactory: AppMainNavigationViewControllerFactory())
        )
    }
}

struct AppMainNavigationViewControllerFactory: MainNavigationViewControllerFactory {

    private static var munimapServerURL: URL = { // TODO move to separate testable URLs struct
        guard let url = URL(string: "https://smart-uni-be.herokuapp.com/munimap?device=mobile") else {
            fatalError("Failed to create munimap server url.")
        }
        return url
    }()

    func makeViewController(for scene: MainNavigationScene) -> UIViewController {
        switch scene {
        case .qrScanner(let delegate):
            return QRScannerViewController(delegate: delegate)
        case .munimap:
            return MunimapViewController(
                munimapServerURL: Self.munimapServerURL,
                webViewHandler: WebViewHandler.shared
            )
        case .arView:
            return ARViewController()
        }
    }
}

private extension QRScannerViewController {

    convenience init(delegate: QRScannerViewControllerDelegate) {
        self.init()

        self.delegate = delegate
    }
}
