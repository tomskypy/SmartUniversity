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
}

final class AppConfigurationProvider {

    static let shared = AppConfigurationProvider()

    let defaultsProvider: UserDefaultsProviding

    init(defaultsProvider: UserDefaultsProviding = UserDefaults.standard) {
        self.defaultsProvider = defaultsProvider
    }
}

extension AppConfigurationProvider: AppConfigurationProviding {

    var isOnboardingHidden: Bool {
        defaultsProvider.bool(for: .isOnboardingHidden(defaultValue: false))
    }
}
