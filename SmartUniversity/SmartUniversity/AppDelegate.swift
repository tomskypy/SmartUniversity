//
//  AppDelegate.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 01/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return ARSceneConfiguration(sceneSession: connectingSceneSession)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

private final class ARSceneConfiguration: UISceneConfiguration {

    private static let configName = "AR Scene Configuration"
    private static let delegateClass = SceneDelegate.self

    init(sceneSession: UISceneSession) {
        super.init(name: Self.configName, sessionRole: sceneSession.role)

        self.delegateClass = Self.delegateClass
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.delegateClass = Self.delegateClass
    }
}
