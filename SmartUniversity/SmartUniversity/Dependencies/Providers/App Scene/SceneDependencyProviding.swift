//
//  SceneDependencyProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 08/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol SceneDependencyProviding {

    var sceneHandler: WindowSceneHandling? { get }

    init()

    func makeRootViewController() -> UIViewController
}
