//
//  OnboardingViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 17/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class OnboardingViewController: BaseViewController<OnboardingScreenView> {

    var titleText: String {
        didSet { screenView?.titleText = titleText }
    }

    var bodyText: String {
        didSet { screenView?.bodyText = bodyText }
    }

    init(titleText: String, bodyText: String) {
        self.titleText = titleText
        self.bodyText = bodyText

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        screenView?.configure(withTitleText: titleText, bodyText: bodyText)
        screenView?.backgroundColor = .white
    }
}
