//
//  SURemoteDataInfoTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 30/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

@testable import SmartUniversity

class SURemoteDataInfoTests: XCTestCase {

    func testAllURLStringAreValidURLs() {
        for remoteDataInfo in SURemoteDataInfo.allCases {
            XCTAssertNotNil(URL(string: remoteDataInfo.jsonURLString))
        }
    }

}
