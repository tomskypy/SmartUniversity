//
//  OnboardingCoordinator.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 23/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {

    func onboardingCoordinatorDidFinish()
    func onboardingCoordinatorDidSkipOnboarding()
}

final class OnboardingCoordinator: NSObject, BaseCoordinator {

    weak var delegate: OnboardingCoordinatorDelegate?

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
            delegate?.onboardingCoordinatorDidFinish()
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
        delegate?.onboardingCoordinatorDidSkipOnboarding()
    }
}

extension OnboardingCoordinator: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        guard gestureRecognizer.isEqual(navigationController.interactivePopGestureRecognizer) else {
            return true
        }

        controllerIndex -= 1
        return true
    }
}

private extension OnboardingViewController {

    convenience init(
        configuration: OnboardingCoordinator.ViewControllerConfiguration,
        delegate: OnboardingViewControllerDelegate
    ) {
        self.init(titleText: configuration.titleText, bodyText: configuration.bodyText, isFinal: configuration.isFinal)

        self.delegate = delegate
        self.action = configuration.action
    }
}
