//
//  PresentationHandler.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

struct PresentationHandler: PresentationHandling {

    func present(_ viewController: UIViewController, onViewController: UIViewController, animated: Bool) {
        onViewController.present(viewController, animated: animated)
    }
}
