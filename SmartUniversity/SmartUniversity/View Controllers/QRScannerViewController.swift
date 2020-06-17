//
//  QRScannerViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/04/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation
import UIKit

protocol QRScannerViewControllerDelegate: AnyObject {

    func qrScannerViewControllerDidSelectContinue(_ qrScannerViewController: QRScannerViewController)
}

class QRScannerViewController: BaseViewController<QRScannerScreenView> {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    weak var delegate: QRScannerViewControllerDelegate?

    private var captureSessionHandler: CaptureSessionHandling
    private var qrPointScanningHandler: QRPointScanningHandling

    private var presentationHandler: PresentationHandling

    /// Tuple containg scanned object's `String` value and its detected bounds within the scanning view.
    var scannedValueCodeObjectBounds: (scannedValue: String, objectBounds: CGRect)?

    init(
        captureSessionHandler: CaptureSessionHandling,
        qrPointScanningHandler: QRPointScanningHandling,
        presentationHandler: PresentationHandling
    ) {
        self.captureSessionHandler = captureSessionHandler
        self.qrPointScanningHandler = qrPointScanningHandler
        self.presentationHandler = presentationHandler
        super.init(nibName: nil, bundle: nil)

        self.captureSessionHandler.delegate = self
        self.qrPointScanningHandler.delegate = self
    }

    required init?(coder: NSCoder) { nil }

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
        screenView?.configureBottomOverlay(
            for: .fail(text: "Sry bro, no way to run on this bad boi. :C \n(device unsupported)")
        )
    }

    #if DEBUG
    private func handleDebugSession() {
        screenView?.configureBottomOverlay(
            for: .success(text: "Debug session, eh?"),
            buttonConfiguration: .init(
                text: "Launch (with default data)",
                color: .darkGray,
                tapHandler: { [weak self] in
                    guard let self = self else { return }

                    self.delegate?.qrScannerViewControllerDidSelectContinue(self)
                }
            )
        )
    }
    #endif
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

        screenView?.configureBottomOverlay(
            for: .success(text: "GJ, you've found a Point!"),
            buttonConfiguration: .init(
                text: "Continue",
                color: .darkGray,
                tapHandler: { [weak self] in
                    guard let self = self else { return }

                    self.delegate?.qrScannerViewControllerDidSelectContinue(self)
                }
            )
        )
    }

    func captureSessionHandler(_ handler: CaptureSessionHandling, didTriggerError error: CaptureSessionError) {

        #if DEBUG
            handleDebugSession()
        #else
            handleSessionFailed()
        #endif
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

        screenView?.showBlurOverlay(maskBounds: scannedValueCodeObjectBounds.objectBounds)
    }

    func qrPointScanningHandler(_ handler: QRPointScanningHandling, couldNotFetchQRPointForScannedValue value: String) {
        screenView?.hideBlurOverlay()
    }
}
