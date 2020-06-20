//
//  AppConfigurationProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 26/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

protocol AppConfigurationProviding {

    var isOnboardingHidden: Bool { get }

    func setDidPassOnboarding()
}

struct AppConfigurationProvider {

    private let defaultsProvider: UserDefaultsProviding

    init(defaultsProvider: UserDefaultsProviding = UserDefaults.standard) {
        self.defaultsProvider = defaultsProvider
    }
}

extension AppConfigurationProvider: AppConfigurationProviding {

    var isOnboardingHidden: Bool {
        defaultsProvider.bool(for: .isOnboardingHidden)
    }

    func setDidPassOnboarding() {
        defaultsProvider.setBool(true, for: .isOnboardingHidden)
    }
}
