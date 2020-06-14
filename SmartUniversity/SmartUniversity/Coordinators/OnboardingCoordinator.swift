//
//  OnboardingCoordinator.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 23/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class OnboardingCoordinator: BaseCoordinator {

    var didFinishHandler: (() -> Void)?

    private let navigationController: NavigationController
    private let dependencies: OnboardingCoordinator.Dependencies

    private var controllerIndex: Int = 0

    required init(navigationController: NavigationController, dependencies: OnboardingCoordinator.Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        pushViewControllerOnIndex(controllerIndex)
    }

    private func pushViewControllerOnIndex(_ index: Int) {
        guard index < dependencies.viewControllerConfigurations.count else {
            didFinishHandler?()
            return
        }

        let viewController = OnboardingViewController(
            configuration: dependencies.viewControllerConfigurations[index],
            delegate: self
        )
        navigationController.pushViewController(viewController)
    }
}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {

    func onboardingViewControllerDidSelectNext(_ viewController: OnboardingViewController) {
        controllerIndex += 1

        pushViewControllerOnIndex(controllerIndex)
    }

    func onboardingViewControllerDidSelectSkip(_ viewController: OnboardingViewController) {
        didFinishHandler?()
    }
}

private extension OnboardingViewController {

    convenience init(
        configuration: OnboardingCoordinator.ViewControllerConfiguration,
        delegate: OnboardingViewControllerDelegate
    ) {
        self.init(titleText: configuration.titleText, bodyText: configuration.bodyText)

        self.delegate = delegate
    }
}
