//
//  RemoteDataProviderTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 30/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

private final class TestableURLSessionDataTask: URLSessionDataTask {

    let onResume: () -> Void

    init(onResume: @escaping () -> Void) {
        self.onResume = onResume
    }

    override func resume() {
        onResume()
    }
}

private final class TestableURLSessionProvider: URLSessionProviding {

    private let dataTaskResponse: String

    init(dataTaskResponse: String) {
        self.dataTaskResponse = dataTaskResponse
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return TestableURLSessionDataTask(onResume: {
            completionHandler(Data(repeating: 5, count: 3), nil, nil)
        })
    } 
}

private struct EmptyDecodable: Decodable {

}

private struct TestableJSONDataInfo: RemoteJSONDataInfo {

    let jsonURLString: String

    init(urlString: String) {
        jsonURLString = urlString
    }
}

final class RemoteDataProviderTests: XCTestCase {

    var dataProvider: RemoteDataProvider!

    override func setUp() {
        dataProvider = RemoteDataProvider()
    }

    func testFetchJSONDataFailsWithInvalidURLString() {
        let dataInfoWithInvalidURL = TestableJSONDataInfo(urlString: "sš.§!ôňä(")
        let expectedFetchError = DataFetchError.invalidURLString
        let expectation = XCTestExpectation(description: "Wait for fetch.")

        dataProvider.fetchJSONData(
            withDataInfo: dataInfoWithInvalidURL
        ) { (_: EmptyDecodable?, error: DataFetchError?) in
            expectation.fulfill()

            XCTAssertNotNil(error)
            XCTAssertEqual(expectedFetchError, error)
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchJSONDataFailsWithUnparsableResponse() {

        let urlSessionProviderWithInvalidResponse = TestableURLSessionProvider(dataTaskResponse: "{{}")
        let expectedFetchError = DataFetchError.parsingError
        let dataProvider = RemoteDataProvider(urlSessionProvider: urlSessionProviderWithInvalidResponse)
        let expectation = XCTestExpectation(description: "Wait for fetch.")

        dataProvider.fetchJSONData(
            withDataInfo: TestableJSONDataInfo(urlString: "www.sme.sk")
        ){ (_: EmptyDecodable?, error: DataFetchError?) in
            expectation.fulfill()

            XCTAssertNotNil(error)
            XCTAssertEqual(expectedFetchError, error)
        }
        wait(for: [expectation], timeout: 10.0)
    }
}

extension RemoteDataProviderTests {

    // MARK: - QRPointsProviding implementation tests

    func testGetAllQRPoints() {
        let expectation = XCTestExpectation(description: "Wait for get.")

        dataProvider.getAllQRPoints { points, error in
            expectation.fulfill()

            XCTAssertNil(error)
            XCTAssertNotNil(points)
        }
        wait(for: [expectation], timeout: 10.0)
    }

}
