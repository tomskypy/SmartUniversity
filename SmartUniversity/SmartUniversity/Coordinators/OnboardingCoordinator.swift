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

    var didFinishHandler: (() -> Void)?

    private lazy var viewControllerConfigurations: [OnboardingControllerConfiguration] = [
        .init(titleText: "Welcome to Smart University App", bodyText: "We will show you around, no worries..."),
        .init(
            titleText: "Second onboarding screen",
            bodyText: "This is the second onboarding screen. You should know something already at this point."
        ),
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
        guard index < viewControllerConfigurations.count else {
            didFinishHandler?()
            return
        }

        let viewController = OnboardingViewController(
            configuration: viewControllerConfigurations[index],
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

    convenience init(configuration: OnboardingControllerConfiguration, delegate: OnboardingViewControllerDelegate) {
        self.init(titleText: configuration.titleText, bodyText: configuration.bodyText)

        self.delegate = delegate
    }
}
