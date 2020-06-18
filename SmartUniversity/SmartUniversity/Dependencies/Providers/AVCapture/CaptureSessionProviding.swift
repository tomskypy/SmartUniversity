//
//  CaptureSessionProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation

protocol CaptureSessionProviding {

    func makeCaptureSession() -> AVCaptureSession
}
