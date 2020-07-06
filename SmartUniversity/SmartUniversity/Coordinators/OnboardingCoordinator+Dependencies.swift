//
//  OnboardingCoordinator+Dependencies.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension OnboardingCoordinator {

    struct ViewControllerConfiguration {
        let titleText: String
        let bodyText: String

        let action: OnboardingViewController.Action?

        let isFinal: Bool

        init(
            titleText: String,
            bodyText: String,
            action: OnboardingViewController.Action? = nil,
            isFinal: Bool = false
        ) {
            self.titleText = titleText
            self.bodyText = bodyText
            self.action = action
            self.isFinal = isFinal
        }
    }

    struct Dependencies {

        let viewControllerConfigurations: [ViewControllerConfiguration]
    }
}
