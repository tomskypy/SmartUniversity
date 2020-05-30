//
//  BaseCoordinator.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 23/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol NavigationController: UIViewController {

    func pushViewController(_ viewController: UIViewController)
    func popViewController()
    func popToRootViewController()
}

protocol BaseCoordinator {

    init(navigationController: NavigationController)

    func start()
}

extension UINavigationController: NavigationController {

    func pushViewController(_ viewController: UIViewController) {
        pushViewController(viewController, animated: true)
    }

    func popViewController() {
        popViewController(animated: true)
    }

    func popToRootViewController() {
        popToRootViewController(animated: true)
    }
}
