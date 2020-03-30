//
//  RemoteJSONDataInfoTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 30/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest
import SmartUniversity

class RemoteJSONDataInfoTests: XCTestCase {

    func testAllURLStringAreValidURLs() {
        for remoteDataInfo in RemoteJSONDataInfo.allCases {
            XCTAssertNotNil(URL(string: remoteDataInfo.jsonURLString))
        }
    }

}
