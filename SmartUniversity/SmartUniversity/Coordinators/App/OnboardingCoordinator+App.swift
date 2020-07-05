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
        .init(
            titleText: "Wel-\ncome",
            bodyText: "... to Smart University app!\n\nThanks for giving it a try, let us show you around."
        ),
        .init(
            titleText: "In-\ndoors",
            bodyText: "The main feature is indoor localization within MUNI's faculties.\n\nWe cannot utilize GPS indoors, so we've come up with QR Points."
        ),
        .init(
            titleText: "QR\nScan-\nner",
            bodyText: "QR Scanner helps you access any QR Point.\n\nThose are posters with a QR code placed strategically around faculties."
        ),
        .init(
            titleText: "muni-\nmap",
            bodyText: "Powered by QR Point's data, you'll be localized on the munimap*.\n\n*munimap - handy MUNI's interactive map of all rooms on all floors within any faculty"
        ),
        .init(
            titleText: "AR\nView",
            bodyText: "Last but hopefully not least there's AR View.\n\nLaunch it and aim the AR preview at the QR Point. Then, simply follow the instructions."
        ),
        .init(
            titleText: "Than-\nks",
            bodyText: "For going all the way through.\n\nWe'll try to condense this somehow in future versions."
        )
    ]
}
