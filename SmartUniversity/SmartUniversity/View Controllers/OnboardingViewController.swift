//
//  OnboardingViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 17/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

final class OnboardingViewController: BaseViewController<OnboardingScreenView> {

    override func viewDidLoad() {
        super.viewDidLoad()

        screenView?.configure(withTitleText: "Test Onboarding Screen", mainText: "bla bla bla")
        screenView?.backgroundColor = .white
    }
}
