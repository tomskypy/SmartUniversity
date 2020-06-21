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

        captureSessionHandler.handleViewDidLoad(view)
        qrPointScanningHandler.handleViewDidLoad(view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        captureSessionHandler.handleViewWillAppear(view)

        screenView?.reset()
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
        guard scannedValueCodeObjectBounds?.scannedValue != outputString else { return }

        scannedValueCodeObjectBounds = (outputString, objectBounds)
        qrPointScanningHandler.qrCodeValueScanned(outputString)

        screenView?.showBlurOverlay(maskBounds: objectBounds)
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

        screenView?.configureBottomOverlay(
            for: .success(text: "GJ, you've found a Point!"),
            buttonConfiguration: .init(
                text: "Continue",
                color: .darkGray,
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

        let hideOverlayHandler = { [weak self] in
            guard let self = self else { return }

            self.screenView?.reset()
            self.scannedValueCodeObjectBounds = nil
        }
        screenView?.configureBottomOverlay(
            for: .fail(text: text),
            buttonConfiguration: .init(text: "Ok", color: .darkGray, tapHandler: hideOverlayHandler)
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
            buttonConfiguration: .init(text: "Launch (debug data)", color: .darkGray, tapHandler: continueTapHandler)
        )
    }
    #endif

}
