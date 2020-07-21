//
//  UIViewSizingTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 09/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

@testable import SmartUniversity

private final class TestableUIView: UIView {

    static let sizeThatFitsHeightReturnValue: CGFloat = 10

    var sizeReceivedInSizeThatFits: CGSize?

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        sizeReceivedInSizeThatFits = size
        
        return CGSize(width: size.width, height: Self.sizeThatFitsHeightReturnValue)
    }

}

final class UIViewSizingTests: XCTestCase {

    private var uiView: TestableUIView!

    override func setUp() {
        uiView = .init()
    }

    func testSizeConstrainedToWidthCallsSizeThatFitsWithCorrectCGSizeParameter() {
        let expectedWidth: CGFloat = 15
        let expectedHeight: CGFloat = .greatestFiniteMagnitude

        _ = uiView.size(constrainedToWidth: expectedWidth)

        XCTAssertEqual(CGSize(width: expectedWidth, height: expectedHeight), uiView.sizeReceivedInSizeThatFits)
    }

    func testHeightConstrainedToWidthCallsSize() {
        let expectedHeight = TestableUIView.sizeThatFitsHeightReturnValue

        let height = uiView.height(constrainedToWidth: 15)

        XCTAssertEqual(expectedHeight, height)
    }

}
