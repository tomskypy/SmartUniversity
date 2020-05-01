//
//  PresentationHandlerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 22/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

private final class TestableViewController: UIViewController {

    var viewControllerToPresentReceivedInPresent: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        viewControllerToPresentReceivedInPresent = viewControllerToPresent
    }
}

final class PresentationHandlerTests: XCTestCase {

    func testPresentDoesPresentViewControllerToPresentOnProvidedViewController() {
        let presentingViewController = TestableViewController()
        let expectedViewControllerToPresent = UIViewController()

        PresentationHandler.shared.present(
            expectedViewControllerToPresent,
            onViewController: presentingViewController,
            animated: true
        )

        XCTAssertEqual(
            expectedViewControllerToPresent,
            presentingViewController.viewControllerToPresentReceivedInPresent
        )
    }

}
