//
//  UIEdgeInsetsInitTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 09/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

class UIEdgeInsetsInitTests: XCTestCase {

    func testInitAllDoesInitiateAllValuesCorrectly() {
        let expectedInsetSize: CGFloat = 13

        let insets = UIEdgeInsets(all: expectedInsetSize)

        XCTAssertEqual(expectedInsetSize, insets.top)
        XCTAssertEqual(expectedInsetSize, insets.bottom)
        XCTAssertEqual(expectedInsetSize, insets.left)
        XCTAssertEqual(expectedInsetSize, insets.right)
    }

}
