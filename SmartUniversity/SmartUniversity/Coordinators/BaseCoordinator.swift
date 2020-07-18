//
//  BaseCoordinator.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 23/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol NavigationController: UIViewController {

    var interactivePopGestureRecognizer: UIGestureRecognizer? { get }

    func pushViewController(_ viewController: UIViewController)
    func popViewController()
    func popToRootViewController()
    func setNavigationBarHidden()
}

protocol BaseCoordinator {
    associatedtype Dependencies

    init(navigationController: NavigationController, dependencies: Dependencies)

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

    func setNavigationBarHidden() {
        setNavigationBarHidden(true, animated: false)
    }
}
