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

    private var captureSessionHandler: CaptureSessionHandling
    private var qrPointScanningHandler: QRPointScanningHandling

    private var presentationHandler: PresentationHandling

    /// Tuple containg scanned object's `String` value and its detected bounds within the scanning view.
    private(set) var scannedValueCodeObjectBounds: (scannedValue: String, objectBounds: CGRect)?

    init(
        captureSessionHandler: CaptureSessionHandling = CaptureSessionHandler(),
        qrPointScanningHandler: QRPointScanningHandling = QRPointScanningHandler(),
        presentationHandler: PresentationHandling = PresentationHandler.shared
    ) {
        self.captureSessionHandler = captureSessionHandler
        self.qrPointScanningHandler = qrPointScanningHandler
        self.presentationHandler = presentationHandler
        super.init(nibName: nil, bundle: nil)

        self.captureSessionHandler.delegate = self
        self.qrPointScanningHandler.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        screenView?.hideBlurOverlay()

        captureSessionHandler.handleViewDidLoad(view)
        qrPointScanningHandler.handleViewDidLoad(view)
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
        presentationHandler.present(controller, onViewController: self, animated: true)
    }
}

extension QRScannerViewController: CaptureSessionHandlerDelegate {

    func captureSessionHandler(
        _ handler: CaptureSessionHandling,
        didLoadPreviewLayer previewLayer: AVCaptureVideoPreviewLayer
    ) {
        screenView?.scannerPreviewLayer = previewLayer
    }

    func captureSessionHandler(
        _ handler: CaptureSessionHandling,
        didReceiveValidOutput outputString: String,
        fromObjectWithBounds objectBounds: CGRect
    ) {
        scannedValueCodeObjectBounds = (outputString, objectBounds)
        qrPointScanningHandler.qrCodeValueScanned(outputString)

        screenView?.showBlurOverlay(maskBounds: objectBounds)
    }

    func captureSessionHandler(_ handler: CaptureSessionHandling, didTriggerError error: CaptureSessionError) {
        handleSessionFailed()
    }
}

extension QRScannerViewController: QRPointScanningHandlerDelegate {

    func qrPointScanningHandler(
        _ handler: QRPointScanningHandling,
        didFetchQRPoint qrPoint: QRPoint,
        forScannedValue value: String
    ) {
        guard
            let scannedValueCodeObjectBounds = scannedValueCodeObjectBounds,
            value == scannedValueCodeObjectBounds.scannedValue
        else { return }

        // TODO enhance/differentiate the UX
        screenView?.showBlurOverlay(maskBounds: scannedValueCodeObjectBounds.objectBounds)
    }

    func qrPointScanningHandler(_ handler: QRPointScanningHandling, couldNotFetchQRPointForScannedValue value: String) {
        screenView?.hideBlurOverlay()
    }
}
