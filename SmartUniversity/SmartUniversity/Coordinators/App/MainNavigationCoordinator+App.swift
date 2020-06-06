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
        let webWindowZoom = munimapWebWindowZoomValue()
        guard let url = URL(string: "https://smart-uni-be.herokuapp.com/munimap?windowZoom=\(webWindowZoom)") else {
            fatalError("Failed to create munimap server url.")
        }
        return url
    }()

    func makeViewController(for scene: MainNavigationScene) -> UIViewController {
        switch scene {
        case .qrScanner:
            return QRScannerViewController()
        case .munimap:
            return MunimapViewController(
                munimapServerURL: Self.munimapServerURL,
                webViewHandler: WebViewHandler.shared
            )
        case .arView:
            return ARViewController()
        }
    }

    private static func munimapWebWindowZoomValue(for screen: UIScreen = UIScreen.main) -> Int {
        screen.scale <= 2 ? 100 : 200
    }
}
