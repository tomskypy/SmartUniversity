//
//  AppCaptureAuthorizationProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation

final class AppCaptureAuthorizationProvider: CaptureAuthorizationStatusProviding {

    static let shared = AppCaptureAuthorizationProvider()

    private init() { }

    var videoCaptureAuthorizationStatus: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }

}
