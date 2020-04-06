//
//  CaptureDeviceProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 07/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation

protocol CaptureDeviceProviding {

    var videoCaptureDevice: AVCaptureDevice? { get }
}

struct CaptureDeviceProvider: CaptureDeviceProviding {

    static let shared = CaptureDeviceProvider()

    let videoCaptureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: .video)

    private init() { }
}
