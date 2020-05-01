//
//  MainNavigationViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 16/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class MainNavigationViewController: UITabBarController {

    init(controllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)

        viewControllers = controllers
    }

    required init?(coder: NSCoder) { nil }
}
