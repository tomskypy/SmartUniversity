//
//  GlobalConfigurationProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum DefaultsBoolKey {
    case isOnboardingHidden(defaultValue: Bool)
}

protocol UserDefaultsProviding {

    func bool(for key: DefaultsBoolKey) -> Bool
}

protocol GlobalConfigurationProviding {

    var isOnboardingHidden: Bool { get }
}
