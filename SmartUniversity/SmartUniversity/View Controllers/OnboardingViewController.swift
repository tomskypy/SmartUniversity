//
//  OnboardingViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 17/05/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {

    func onboardingViewControllerDidSelectNext(_ viewController: OnboardingViewController)

    func onboardingViewControllerDidSelectSkip(_ viewController: OnboardingViewController)
}

class OnboardingViewController: BaseViewController<OnboardingScreenView> {
    typealias ActionCompletion = () -> Void
    typealias Action = (OnboardingViewController, @escaping ActionCompletion) -> Void

    weak var delegate: OnboardingViewControllerDelegate?

    var action: Action?

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

        screenView?.didTapNextHandler = { [unowned self] in

            if let action = self.action {
                action(self, { self.delegate?.onboardingViewControllerDidSelectNext(self) })
            } else {
                self.delegate?.onboardingViewControllerDidSelectNext(self)
            }
        }
        screenView?.didTapSkipHandler = { [unowned self] in
            self.delegate?.onboardingViewControllerDidSelectSkip(self)
        }
    }
}
