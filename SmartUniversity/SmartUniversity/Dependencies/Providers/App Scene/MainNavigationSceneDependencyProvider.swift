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

    var mainNavigationCoordinator: MainNavigationCoordinator?

    convenience init() {
        self.init(navigationController: UINavigationController())
    }

    init(navigationController: NavigationController) {
        self.navigationController = navigationController

        navigationController.setNavigationBarHidden()
    }

    func makeRootViewController() -> UIViewController {
        navigationController
    }
}

extension MainNavigationSceneDependencyProvider: WindowSceneHandling {

    func windowWillBecomeVisible(_ window: UIWindow) {
        mainNavigationCoordinator = MainNavigationCoordinator(navigationController: navigationController)
    }

    func windowDidBecomeVisible(_ window: UIWindow) {
        mainNavigationCoordinator?.start()
    }
}
