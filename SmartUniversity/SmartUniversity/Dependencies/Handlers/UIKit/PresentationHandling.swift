//
//  PresentationHandling.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 21/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol PresentationHandling {

    func present(_ viewController: UIViewController, onViewController: UIViewController, animated: Bool)
}

struct PresentationHandler: PresentationHandling {

    static var shared = PresentationHandler()

    private init() { }

    func present(_ viewController: UIViewController, onViewController: UIViewController, animated: Bool) {
        onViewController.present(viewController, animated: animated)
    }
}
