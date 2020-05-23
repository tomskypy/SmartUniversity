//
//  BaseCoordinator.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 23/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol NavigationController {

    func pushViewController(_ viewController: UIViewController)
}

protocol BaseCoordinator {

    init(navigationController: NavigationController)
}

extension UINavigationController: NavigationController {

    func pushViewController(_ viewController: UIViewController) {
        pushViewController(viewController, animated: true)
    }
}
