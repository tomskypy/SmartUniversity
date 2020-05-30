//
//  MainNavigationSceneDependencyProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 17/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class MainNavigationSceneDependencyProvider: SceneDependencyProviding {

    let navigationController: NavigationController

    var sceneHandler: WindowSceneHandling? { self }

    var onboardingCoordinator: OnboardingCoordinator?

    private lazy var munimapServerURL: URL = {
        let webWindowZoom = munimapWebWindowZoomValue()
        guard let url = URL(string: "https://smart-uni-be.herokuapp.com/munimap?windowZoom=\(webWindowZoom)") else {
            fatalError("Failed to create munimap server url.")
        }
        return url
    }()

    convenience init() {
        self.init(navigationController: UINavigationController())
    }

    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }

    func makeRootViewController() -> UIViewController {
        navigationController
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
        controller.tabBarItem = UITabBarItem(title: "QR Scan", image: UIImage(systemName: "qrcode.viewfinder"), tag: 2)

        return controller
    }

    private func makeTabBarOnboardingViewController() -> UIViewController {
        let controller = UINavigationController()
        controller.tabBarItem = UITabBarItem(
            title: "Onboarding",
            image: UIImage(systemName: "exclamationmark.bubble"),
            tag: 3
        )

        return controller
    }

    private func munimapWebWindowZoomValue(for screen: UIScreen = UIScreen.main) -> Int {
        screen.scale <= 2 ? 100 : 200
    }

}

extension MainNavigationSceneDependencyProvider: WindowSceneHandling {

    func windowWillBecomeVisible(_ window: UIWindow) { }

    func windowDidBecomeVisible(_ window: UIWindow) {
        onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator?.didFinishHandler = {
            print("lol")
        }
        onboardingCoordinator?.start()
    }
}
