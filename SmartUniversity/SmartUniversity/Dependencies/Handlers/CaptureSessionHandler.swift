//
//  CaptureSessionHandler.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation
import UIKit

protocol CaptureSessionHandling {

    func handleViewDidLoad(_ view: UIView)
}

final class CaptureSessionHandler: CaptureSessionHandling {

    static let shared = CaptureSessionHandler()

    private(set) var previewLayer: AVCaptureVideoPreviewLayer {
        didSet {
            previewLayer.videoGravity = .resizeAspectFill
        }
    }

    private(set) var captureSession: AVCaptureSession {
        didSet {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        }
    }

    init(captureSession: AVCaptureSession = AVCaptureSession()) {
        self.captureSession = captureSession
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    }

    func handleViewDidLoad(_ view: UIView) {
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
    }
}
