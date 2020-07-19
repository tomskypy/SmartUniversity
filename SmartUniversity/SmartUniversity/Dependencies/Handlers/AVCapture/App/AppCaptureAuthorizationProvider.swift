//
//  AppCaptureAuthorizationProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation

final class AppCaptureAuthorizationProvider: CaptureAuthorizationStatusProviding, CaptureAuthorizationRequesting {

    static let shared = AppCaptureAuthorizationProvider()

    private init() { }

    var videoCaptureAuthorizationStatus: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }

    func requestAccessForVideo(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            completion(granted)
        }
    }
}
