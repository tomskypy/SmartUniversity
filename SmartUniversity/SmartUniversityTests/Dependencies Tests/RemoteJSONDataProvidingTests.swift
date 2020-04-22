//
//  RemoteJSONDataProvidingTests.swift
//  SmartUniversityTests
//
//  Created by Tomas Skypala on 22/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import XCTest

private struct EmptyDecodable: Decodable {
    var jsonURLString: String = ""
}

private struct EmptyRemoteJSONDataInfo: RemoteJSONDataInfo {
    var jsonURLString: String = ""
}

private final class TestableRemoteJSONDataProvider: RemoteJSONDataProviding {

    var queueReceivedInFetch: DispatchQueue? = nil

    func fetchJSONData<JSONData>(
        withDataInfo info: RemoteJSONDataInfo,
        completion: @escaping (JSONData?, DataFetchError?) -> Void,
        onQueue queue: DispatchQueue
    ) where JSONData : Decodable {
        queueReceivedInFetch = queue
    }
}

final class RemoteJSONDataProvidingTests: XCTestCase {

    func testFetchJSONDataIsCalledWithGlobalUserInitiatedDispatchQueue() {
        let testableProvider = TestableRemoteJSONDataProvider()
        XCTAssertNil(testableProvider.queueReceivedInFetch)
        let expectedDispatchQOSClass = DispatchQoS.QoSClass.userInitiated
        let expectedDispatchQueue = DispatchQueue.global(qos: expectedDispatchQOSClass)

        testableProvider.fetchJSONData(
            withDataInfo: EmptyRemoteJSONDataInfo(),
            completion: {(_: EmptyDecodable?, _) -> Void in }
        )

        XCTAssertEqual(expectedDispatchQOSClass, testableProvider.queueReceivedInFetch?.qos.qosClass)
        XCTAssertEqual(expectedDispatchQueue, testableProvider.queueReceivedInFetch)
    }

}
