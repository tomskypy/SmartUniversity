//
//  MainNavigationViewControllerTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 18/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

final class MainNavigationViewControllerTests: XCTestCase {

    func testInitSetsUpTabBarViewControllersCorrectly() {
        let expectedViewControllers = [
            UIViewController(),
            UICollectionViewController()
        ]

        let tabBarController = MainNavigationViewController(controllers: expectedViewControllers) as UITabBarController

        XCTAssertEqual(expectedViewControllers, tabBarController.viewControllers)
    }

}
