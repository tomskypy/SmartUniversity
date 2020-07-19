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

    func testRootViewControllerIsMainNavigationViewController() {
        let expectedController = UINavigationController()

        let provider = MainNavigationSceneDependencyProvider(navigationController: expectedController)
        let rootViewController = provider.makeRootViewController()

        XCTAssertEqual(expectedController, rootViewController)
    }

}
