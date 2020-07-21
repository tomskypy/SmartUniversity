//
//  CaptureSessionHandlerDelegate.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 07/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation

enum CaptureSessionError: Error {
    case captureNotAuthorized

    case videoInputUnavailable
    case metadataOutputUnavailable
}

protocol CaptureSessionHandlerDelegate: AnyObject {

    func captureSessionHandler(
        _ handler: CaptureSessionHandling,
        didLoadPreviewLayer previewLayer: AVCaptureVideoPreviewLayer
    )

    func captureSessionHandler(
        _ handler: CaptureSessionHandling,
        didReceiveValidOutput outputString: String,
        fromObjectWithBounds objectBounds: CGRect
    )

    func captureSessionHandler(_ handler: CaptureSessionHandling, didTriggerError error: CaptureSessionError)
}
