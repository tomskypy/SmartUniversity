//
//  AppDelegate.swift
//  BareCameraTest
//
//  Created by Tomas Skypala on 01/08/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit
import BaseAppCoordination

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        SceneConfiguration<MainNavigationSceneDependencyProvider>(sceneSession: connectingSceneSession)
    }
}
