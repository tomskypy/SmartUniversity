//
//  OnboardingCoordinator+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension OnboardingCoordinator {

    convenience init(navigationController: NavigationController) {
        self.init(
            navigationController: navigationController,
            dependencies: .init(viewControllerConfigurations: AppOnboardingDependencies.viewControllerConfigurations)
        )
    }
}

enum AppOnboardingDependencies {

    static let viewControllerConfigurations: [OnboardingCoordinator.ViewControllerConfiguration] = [
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
}
