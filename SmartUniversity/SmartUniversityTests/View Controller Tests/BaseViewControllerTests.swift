//
//  BaseViewControllerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 09/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

private final class TestableScreenView: UIView, BaseScreenView {

    var didReceiveSetupSubviews: Bool = false

    func setupSubviews() {
        didReceiveSetupSubviews = true
    }

}

private final class TestableBaseViewController: BaseViewController<TestableScreenView> { }

final class BaseViewControllerTests: XCTestCase {

    private var baseViewController: TestableBaseViewController!

    override func setUp() {
        baseViewController = .init()
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
