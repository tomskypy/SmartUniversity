//
//  AppConfigurationProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 26/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

struct AppConfigurationProvider {

    let defaultsProvider: UserDefaultsProviding

    init(defaultsProvider: UserDefaultsProviding) {
        self.defaultsProvider = defaultsProvider
    }

}

extension AppConfigurationProvider: GlobalConfigurationProviding {

    var isOnboardingHidden: Bool {
        defaultsProvider.bool(for: .isOnboardingHidden(defaultValue: false))
    }
}
