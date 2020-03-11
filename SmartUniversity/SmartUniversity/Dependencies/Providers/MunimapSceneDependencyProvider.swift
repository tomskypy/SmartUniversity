//
//  MunimapSceneDependencyProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 11/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class MunimapSceneDependencyProvider: SceneDependencyProviding {

    var sceneHandler: WindowSceneHandling?

    private lazy var munimapServerURL: URL = {
        guard let url = URL(string: "https://08668375-551f-4033-a3b8-f1f6715dfb79.htmlpasta.com") else {
            fatalError("Failed to create munimap server url.")
        }
        return url
    }()

    func makeRootViewController() -> UIViewController {
        return MunimapViewController(munimapServerURL: munimapServerURL, webViewHandler: WebViewHandler.shared)
    }
}
