//
//  UIViewAddSubviewsTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 10/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

final class UIViewAddSubviewsTests: XCTestCase {

    func testAddSubviewsAddsSubviewsCorrectly() {
        let view = UIView()

        let subview1 = UILabel()
        let subview2 = UIImageView()

        view.addSubviews(subview1, subview2)

        XCTAssertEqual(2, view.subviews.count)
        XCTAssertEqual(subview1, view.subviews[0])
        XCTAssertEqual(subview2, view.subviews[1])
    }
}
