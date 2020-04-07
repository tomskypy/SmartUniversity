//
//  QRScannerViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation
import UIKit

class QRScannerViewController: BaseViewController<QRScannerScreenView> {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    let captureSessionHandler: CaptureSessionHandling

    init(captureSessionHandler: CaptureSessionHandling = CaptureSessionHandler()) {
        self.captureSessionHandler = captureSessionHandler
        super.init(nibName: nil, bundle: nil)

        captureSessionHandler.setDelegate(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        screenView?.hideBlurOverlay()
        
        captureSessionHandler.handleViewDidLoad(view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        captureSessionHandler.handleViewWillAppear(view)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        captureSessionHandler.handleViewWillDisappear(view)
    }

    private func handleSessionFailed() {
        let controller = UIAlertController(
            title: "Device not supported",
            message: "Your device does not support code scanning with a camera.",
            preferredStyle: .alert
        )
        controller.addAction(UIAlertAction(title: "OK", style: .default))
        present(controller, animated: true)
    }
}

extension QRScannerViewController: CaptureSessionHandlerDelegate {

    func captureSessionHandler(
        _ handler: CaptureSessionHandler,
        didLoadPreviewLayer previewLayer: AVCaptureVideoPreviewLayer
    ) {
        screenView?.scannerPreviewLayer = previewLayer
    }

    func captureSessionHandler(
        _ handler: CaptureSessionHandler,
        didReceiveValidOutput outputString: String,
        fromObjectWithBounds objectBounds: CGRect
    ) {
        screenView?.showBlurOverlay(maskBounds: objectBounds)
    }

    func captureSessionHandler(_ handler: CaptureSessionHandler, didTriggerError error: CaptureSessionError) {
        handleSessionFailed()
    }
}
