//
//  VerticalFrameBasedViewTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 09/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

@testable import SmartUniversity

private final class TestableVerticalFrameBasedViewSubclass: VerticalFrameBasedView {

    static let expectedMargins = UIEdgeInsets(top: 3, left: 16, bottom: 11, right: 19)

    override var insets: UIEdgeInsets { Self.expectedMargins }

    static let subview1Frame = CGRect(x: 5, y: 5, width: 10, height: 20)
    static let subview2Frame = CGRect(x: 0, y: subview1Frame.maxY + 5, width: 15, height: 20)

    static let expectedSizeThatFitsHeight = subview2Frame.maxY + expectedMargins.bottom

    let subview1 = UILabel()
    let subview2 = UIButton()

    init() {
        super.init(frame: .zero)

        addSubviews(subview1, subview2)
    }

    required init?(coder: NSCoder) { nil }

    override func frames(forWidth _: CGFloat) -> [(view: UIView, frame: CGRect)] {
        [(subview1, Self.subview1Frame), (subview2, Self.subview2Frame)]
    }
}

final class VerticalFrameBasedViewSubclassTests: XCTestCase {

    private var frameBasedViewSubclass: TestableVerticalFrameBasedViewSubclass!

    override func setUp() {
        frameBasedViewSubclass = TestableVerticalFrameBasedViewSubclass()
    }

    func testMarginsAreOverriden() {
        let expectedMargins = TestableVerticalFrameBasedViewSubclass.expectedMargins

        XCTAssertEqual(expectedMargins, frameBasedViewSubclass.insets)
    }

    func testLayoutSubviewsSetsSubviewFramesCorrectly() {
        // Precondition check
        XCTAssertEqual(.zero, frameBasedViewSubclass.subview1.frame)
        XCTAssertEqual(.zero, frameBasedViewSubclass.subview2.frame)
        let expectedSubview1Frame = TestableVerticalFrameBasedViewSubclass.subview1Frame
        let expectedSubview2Frame = TestableVerticalFrameBasedViewSubclass.subview2Frame

        frameBasedViewSubclass.layoutSubviews()

        XCTAssertEqual(expectedSubview1Frame, frameBasedViewSubclass.subview1.frame)
        XCTAssertEqual(expectedSubview2Frame, frameBasedViewSubclass.subview2.frame)
    }

    func testSizeThatFitsReturnsExpectedHeight() {
        let expectedWidth: CGFloat = 100
        let expectedHeight = TestableVerticalFrameBasedViewSubclass.expectedSizeThatFitsHeight

        let size = frameBasedViewSubclass.sizeThatFits(CGSize(width: expectedWidth, height: .greatestFiniteMagnitude))

        XCTAssertEqual(expectedWidth, size.width)
        XCTAssertEqual(expectedHeight, size.height)
    }
}


final class VerticalFrameBasedViewTests: XCTestCase {

    private var frameBasedView: VerticalFrameBasedView!

    override func setUp() {
        frameBasedView = .init()
    }

    func testBaseMarginsAreAllZero() {
        let expectedMarginSize: CGFloat = 0

        XCTAssertEqual(expectedMarginSize, frameBasedView.insets.top)
        XCTAssertEqual(expectedMarginSize, frameBasedView.insets.bottom)
        XCTAssertEqual(expectedMarginSize, frameBasedView.insets.left)
        XCTAssertEqual(expectedMarginSize, frameBasedView.insets.right)
    }

    func testBaseFramesReturnZeroForAllSubviews() {
        let view = VerticalFrameBasedView()
        let subview1 = UIView()
        let subview2 = UILabel()

        let expectedFrame = CGRect.zero

        view.addSubviews(subview1, subview2)
        let frames = view.frames(forWidth: 0)

        for (view, frame) in frames {
            XCTAssertTrue(
                view.isEqual(subview1) || view.isEqual(subview2),
                "Unexpected subview-frame tuple found in frames."
            )

            XCTAssertEqual(expectedFrame, frame)
        }
    }
}
