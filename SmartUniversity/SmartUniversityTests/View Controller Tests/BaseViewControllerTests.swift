//
//  BaseViewControllerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 09/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

class TestableScreenView: UIView, BaseScreenView {

    var didReceiveSetupSubviews: Bool = false

    func setupSubviews() {
        didReceiveSetupSubviews = true
    }

}

class TestableBaseViewController: BaseViewController<TestableScreenView> {

}

class BaseViewControllerTests: XCTestCase {

    var baseViewController: TestableBaseViewController!

    override func setUp() {
        baseViewController = TestableBaseViewController()
    }

    func testLoadViewInitsScreenViewWithCorrectType() {
        baseViewController.loadView()

        XCTAssertTrue(TestableScreenView.self == type(of: baseViewController.screenView!))
    }

    func testLoadViewDoesCallSetupSubviewsOnScreenView() {
        baseViewController.loadView()

        XCTAssertTrue(baseViewController.screenView!.didReceiveSetupSubviews)
    }
}
