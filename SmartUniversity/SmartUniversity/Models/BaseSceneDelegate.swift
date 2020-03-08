//
//  BaseSceneDelegate.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 08/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol SceneDelegateProtocol: UIResponder, UIWindowSceneDelegate {

    func windowDidLoad(_ window: UIWindow)
}

open class BaseSceneDelegate: UIResponder, SceneDelegateProtocol {

    public var window: UIWindow?

    public func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        windowDidLoad(window)
    }

    open func windowDidLoad(_ window: UIWindow) {
        self.window = window
    }
}
