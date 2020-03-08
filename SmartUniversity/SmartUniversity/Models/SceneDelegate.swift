//
//  SceneDelegate.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 01/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class SceneDelegate<DependencyProvider: SceneDependencyProviding>: UIResponder, UIWindowSceneDelegate {

    let dependencyProvider = DependencyProvider()

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = dependencyProvider.makeRootViewController()

        dependencyProvider.sceneHandler?.windowWillBecomeVisible(window)
        window.makeKeyAndVisible()
        dependencyProvider.sceneHandler?.windowDidBecomeVisible(window)
    }

}
