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

struct CaptureSessionProvider: CaptureSessionProviding {

    func makeCaptureSession() -> AVCaptureSession { .init() }
}
