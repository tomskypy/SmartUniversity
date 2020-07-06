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

    func qrScannerViewController(
        _ qrScannerViewController: QRScannerViewController,
        didSelectContinueWith qrPoint: QRPoint
    )
}

class QRScannerViewController: BaseViewController<QRScannerScreenView> {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    weak var delegate: QRScannerViewControllerDelegate?

    private static let fadeInAnimationLength = 0.45
    private static let fadeOutAnimationLength = 0.15

    private var captureSessionHandler: CaptureSessionHandling
    private var qrPointScanningHandler: QRPointScanningHandling

    private var presentationHandler: PresentationHandling

    private var hasCaptureSessionError: Bool = false

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

        captureSessionHandler.handleViewDidLoad(view)
        qrPointScanningHandler.handleViewDidLoad(view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if hasCaptureSessionError == false {
            reset()
        }

        captureSessionHandler.handleViewWillAppear(view)

        UIView.animate(withDuration: Self.fadeInAnimationLength, delay: 0, options: .curveEaseIn, animations: {
            self.view.alpha = 1.0
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        captureSessionHandler.handleViewWillDisappear(view)

        UIView.animate(withDuration: Self.fadeOutAnimationLength, animations: {
            self.view.alpha = 0
        })
    }

    private func handleSessionFailed() {
        screenView?.configureBottomOverlay(
            for: .fail(text: "Sry bro, no way to run on this bad boi. :C \n(device unsupported)")
        )
    }

    private func reset() {
        screenView?.reset()
        scannedValueCodeObjectBounds = nil

        screenView?.configureBottomOverlay(
            for: .neutral(text: "Scanning for Smart University Point QR code...")
        )
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
        screenView?.showBlurOverlay(maskBounds: objectBounds)

        guard scannedValueCodeObjectBounds?.scannedValue != outputString else { return }

        scannedValueCodeObjectBounds = (outputString, objectBounds)
        qrPointScanningHandler.qrCodeValueScanned(outputString)
    }

    func captureSessionHandler(_ handler: CaptureSessionHandling, didTriggerError error: CaptureSessionError) {
        hasCaptureSessionError = true

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

        screenView?.configureBottomOverlay(
            for: .success(text: "GJ, you've found a Point!"),
            buttonConfiguration: .init(
                text: "Continue",
                tapHandler: { [weak self] in
                    guard let self = self else { return }

                    self.delegate?.qrScannerViewController(self, didSelectContinueWith: qrPoint)
                }
            )
        )
    }

    func qrPointScanningHandler(
        _ handler: QRPointScanningHandling,
        couldNotParseQRPointIDForScannedValue value: String
    ) {
        showFailBottomOverlay(withText: "Unknown scanned code.")
    }

    func qrPointScanningHandler(
        _ handler: QRPointScanningHandling,
        couldNotFetchQRPointDataForScannedValue value: String
    ) {
        showFailBottomOverlay(withText: "Cannot fetch Point data for scanned code.")
    }

    private func showFailBottomOverlay(withText text: String) {
        screenView?.hideBlurOverlay()

        let hideOverlayHandler: () -> Void = { [weak self] in
            self?.reset()
        }
        screenView?.configureBottomOverlay(
            for: .fail(text: text),
            buttonConfiguration: .init(text: "Ok", tapHandler: hideOverlayHandler)
        )
    }
}

private extension QRScannerViewController {

    #if DEBUG
    private func handleDebugSession() {
        let continueTapHandler = { [weak self] in
            guard let self = self else { return }

            self.delegate?.qrScannerViewController(
                self,
                didSelectContinueWith: QRPoint(
                    uuidString: "",
                    label: "",
                    muniMapPlaceID: "",
                    rooms: [
                        ARLocalizedObjectData(
                            label: "test1",
                            dimensions: .init(width: 2, height: 2, length: 2),
                            position: .init(right: 0, up: 0, front: 10),
                            tint: "#"
                        ),
                        ARLocalizedObjectData(
                            label: "test2",
                            dimensions: .init(width: 1, height: 1, length: 1),
                            position: .init(right: 0, up: 3, front: 10),
                            tint: "#008080FF"
                        )
                ])
            )
        }

        screenView?.configureBottomOverlay(
            for: .success(text: "Debug session, eh?"),
            buttonConfiguration: .init(text: "Launch (debug data)", tapHandler: continueTapHandler)
        )
    }
    #endif

}
