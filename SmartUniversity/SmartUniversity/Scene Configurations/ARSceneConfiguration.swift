//
//  ARSceneConfiguration.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class ARSceneConfiguration: UISceneConfiguration {

    private static let configName = "AR Scene Configuration"
    private static let delegateClass = SceneDelegate<ARSceneDependencyProvider>.self

    init(sceneSession: UISceneSession) {
        super.init(name: Self.configName, sessionRole: sceneSession.role)

        self.delegateClass = Self.delegateClass
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.delegateClass = Self.delegateClass
    }
}
