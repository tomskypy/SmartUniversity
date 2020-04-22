//
//  CaptureSessionProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 07/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation

protocol CaptureSessionProviding {

    func makeCaptureSession() -> AVCaptureSession
}

final class CaptureSessionProvider: CaptureSessionProviding {

    static let shared = CaptureSessionProvider()

    func makeCaptureSession() -> AVCaptureSession {
        AVCaptureSession()
    }

    private init() { }
}
