//
//  MainNavigationCoordinator+Dependencies.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

enum MainNavigationScene {
    case qrScanner
    case munimap
    case arView
}

protocol MainNavigationViewControllerFactory {

    func makeViewController(for scene: MainNavigationScene) -> UIViewController
}

extension MainNavigationCoordinator {

    struct Dependencies {

        let viewControllerFactory: MainNavigationViewControllerFactory
    }
}
