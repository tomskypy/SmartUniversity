//
//  AppConfigurationProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 26/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum DefaultsBoolKey {
    case isOnboardingHidden(defaultValue: Bool)
}

protocol UserDefaultsProviding {

    func bool(for key: DefaultsBoolKey) -> Bool
}

protocol ConfigurationProviding {

    var isOnboardingHidden: Bool { get }
}

struct AppConfigurationProvider {

    let defaultsProvider: UserDefaultsProviding

    init(defaultsProvider: UserDefaultsProviding) {
        self.defaultsProvider = defaultsProvider
    }

}

extension AppConfigurationProvider: ConfigurationProviding {

    var isOnboardingHidden: Bool {
        defaultsProvider.bool(for: .isOnboardingHidden(defaultValue: false))
    }
}
