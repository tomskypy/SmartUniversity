//
//  MainNavigationSceneDependencyProviderTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 18/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

@testable import SmartUniversity

final class MainNavigationSceneDependencyProviderTests: XCTestCase {

    private var provider: MainNavigationSceneDependencyProvider!

    override func setUp() {
        provider = .init()
    }

//    func testRootViewControllerIsMainNavigationViewController() { // TODO rework
//        let rootViewController = provider.makeRootViewController()
//
//        XCTAssertTrue(MainNavigationViewController.self == type(of: rootViewController))
//    }
//
//    func testRootTabBarViewControllerHasCorrectTypeOfViewControllers() {
//        let tabViewControllers = (provider.makeRootViewController() as! UITabBarController).viewControllers!
//
//        XCTAssertTrue(MunimapViewController.self == type(of: tabViewControllers[0]))
//        XCTAssertTrue(QRScannerViewController.self == type(of: tabViewControllers[1]))
//    }

}
