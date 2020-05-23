//
//  OnboardingCoordinator.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 23/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

private struct OnboardingControllerConfiguration {
    let titleText: String
    let bodyText: String
}

class OnboardingCoordinator: BaseCoordinator {

    private lazy var viewControllerConfigurations: [OnboardingControllerConfiguration] = [
        .init(titleText: "Welcome to SmartUniversity", bodyText: "We will show you around, no worries..."),
        .init(
            titleText: "Second onboarding screen",
            bodyText: "This is the second onboarding screen. You should know something already at this point."),
        .init(
            titleText: "Last onboarding screen",
            bodyText: "Here you have last chance to grasp some info. Good luck."
        )
    ]

    private var controllerIndex: Int = 0

    private let navigationController: NavigationController

    required init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        pushViewControllerOnIndex(controllerIndex)
    }

    private func pushViewControllerOnIndex(_ index: Int) {
        navigationController.pushViewController(
            OnboardingViewController(configuration: viewControllerConfigurations[index])
        )
    }

}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {

    func onboardingViewControllerDidSelectNext(_ viewController: OnboardingViewController) {
        controllerIndex += 1

        pushViewControllerOnIndex(controllerIndex)
    }
}

private extension OnboardingViewController {

    convenience init(configuration: OnboardingControllerConfiguration) {
        self.init(titleText: configuration.titleText, bodyText: configuration.bodyText)
    }
}
