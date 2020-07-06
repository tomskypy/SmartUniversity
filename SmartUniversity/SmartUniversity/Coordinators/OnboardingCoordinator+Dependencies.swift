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

        let action: ((UIViewController) -> Void)?

        init(titleText: String, bodyText: String, action: ((UIViewController) -> Void)? = nil) {
            self.titleText = titleText
            self.bodyText = bodyText
            self.action = action
        }
    }

    struct Dependencies {

        let viewControllerConfigurations: [ViewControllerConfiguration]
    }
}
