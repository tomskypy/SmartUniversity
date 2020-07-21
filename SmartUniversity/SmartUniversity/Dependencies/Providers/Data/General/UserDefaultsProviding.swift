//
//  UserDefaultsProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 20/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum DefaultsBoolKey {
    case isOnboardingHidden
}

protocol UserDefaultsProviding {

    func bool(for key: DefaultsBoolKey) -> Bool

    func setBool(_ value: Bool, for key: DefaultsBoolKey)
}

extension UserDefaults: UserDefaultsProviding {

    func bool(for key: DefaultsBoolKey) -> Bool {
        bool(forKey: key.keyString)
    }

    func setBool(_ value: Bool, for key: DefaultsBoolKey) {
        set(value, forKey: key.keyString)
    }
}

private extension DefaultsBoolKey {

    var keyString: String {
        String(reflecting: self)
    }
}
