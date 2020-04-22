//
//  MainNavigationSceneDependencyProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 17/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class MainNavigationSceneDependencyProvider: SceneDependencyProviding {

    var sceneHandler: WindowSceneHandling?

    private lazy var munimapServerURL: URL = {
        let webWindowZoom = munimapWebWindowZoomValue()
        guard let url = URL(string: "https://smart-uni-be.herokuapp.com/munimap?windowZoom=\(webWindowZoom)") else {
            fatalError("Failed to create munimap server url.")
        }
        return url
    }()

    func makeRootViewController() -> UIViewController {
        MainNavigationViewController(controllers: [
            makeTabBarMunimapViewController(),
            makeTabBarQRScannerViewController()
        ])
    }

    private func makeTabBarMunimapViewController() -> UIViewController {
        let controller = MunimapViewController(
            munimapServerURL: munimapServerURL,
            webViewHandler: WebViewHandler.shared
        )
        controller.tabBarItem = UITabBarItem(title: "MUNIMap", image: UIImage(systemName: "map"), tag: 0)

        return controller
    }

    private func makeTabBarARViewController() -> UIViewController {
        let controller = ARViewController()
        controller.tabBarItem = UITabBarItem(title: "AR View", image: UIImage(systemName: "qrcode.viewfinder"), tag: 1)

        return controller
    }

    private func makeTabBarQRScannerViewController() -> UIViewController {
        let controller = QRScannerViewController()
        controller.tabBarItem = UITabBarItem(title: "QR Scan", image: UIImage(systemName: "qrcode.viewfinder"), tag: 1)

        return controller
    }

    private func munimapWebWindowZoomValue(for screen: UIScreen = UIScreen.main) -> Int {
        screen.scale <= 2 ? 100 : 200
    }
}
