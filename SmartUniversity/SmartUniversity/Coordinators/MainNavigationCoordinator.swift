//
//  MainNavigationCoordinator.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class MainNavigationCoordinator: BaseCoordinator {

    let navigationController: NavigationController
    let dependencies: Dependencies

    private(set) var onboardingCoordinator: OnboardingCoordinator?

    init(navigationController: NavigationController, dependencies: MainNavigationCoordinator.Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        navigationController.pushViewController(
            dependencies.viewControllerFactory.makeViewController(for: .qrScanner(delegate: self))
        )

        // TODO add userdefaults check
        onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator?.didFinishHandler = {
            self.navigationController.popToRootViewController()
        }
        onboardingCoordinator?.start()
    }
}

extension MainNavigationCoordinator: QRScannerViewControllerDelegate {

    func qrScannerViewControllerDidSelectContinue(_ qrScannerViewController: QRScannerViewController) {
        let postScanningViewController = ARMapPageViewController(
            arViewController: dependencies.viewControllerFactory.makeViewController(for: .arView),
            muniMapViewController: dependencies.viewControllerFactory.makeViewController(for: .munimap)
        )
        navigationController.pushViewController(postScanningViewController)
    }

}
