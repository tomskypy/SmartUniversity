//
//  OnboardingCoordinator+Dependencies.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

extension OnboardingCoordinator {

    struct ViewControllerConfiguration {
        let titleText: String
        let bodyText: String
    }

    struct Dependencies {

        let viewControllerConfigurations: [ViewControllerConfiguration]
    }
}
