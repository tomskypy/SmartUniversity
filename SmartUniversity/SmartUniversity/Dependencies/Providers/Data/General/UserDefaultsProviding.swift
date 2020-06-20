//
//  UserDefaultsProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 20/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum DefaultsBoolKey {
    case isOnboardingHidden(defaultValue: Bool)
}

protocol UserDefaultsProviding {

    func bool(for key: DefaultsBoolKey) -> Bool
}

extension UserDefaults: UserDefaultsProviding {

    func bool(for key: DefaultsBoolKey) -> Bool {
        bool(forKey: key.keyString)
    }
}

private extension DefaultsBoolKey {

    var keyString: String {
        String(reflecting: self)
    }
}
