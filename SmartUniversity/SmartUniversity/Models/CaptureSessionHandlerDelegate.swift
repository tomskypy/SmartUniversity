//
//  CaptureSessionHandlerDelegate.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 07/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation

enum CaptureSessionError: Error {
    case videoInputUnavailable
    case metadataOutputUnavailable
}

protocol CaptureSessionHandlerDelegate: AnyObject {

    func captureSessionHandler(
        _ handler: CaptureSessionHandler,
        didLoadPreviewLayer previewLayer: AVCaptureVideoPreviewLayer
    )

    func captureSessionHandler(_ handler: CaptureSessionHandler, didTriggerError error: CaptureSessionError)
}
