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
        didSelectContinueWith qrPoint: QRPoint?
    )
}

class QRScannerViewController: BaseViewController<QRScannerScreenView> {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    weak var delegate: QRScannerViewControllerDelegate?

    private static let fadeInAnimationLength = 0.45
    private static let fadeOutAnimationLength = 0.15

    private let externalAppLauncher: ExternalAppLaunching
    private let authorizationStatusProvider: CaptureAuthorizationStatusProviding
    private let authorizationRequester: CaptureAuthorizationRequesting

    private var captureSessionHandler: CaptureSessionHandling
    private var qrPointScanningHandler: QRPointScanningHandling

    private var presentationHandler: PresentationHandling

    private var captureSessionError: CaptureSessionError?

    /// Tuple containg scanned object's `String` value and its detected bounds within the scanning view.
    var scannedValueCodeObjectBounds: (scannedValue: String, objectBounds: CGRect)?

    init(
        captureSessionHandler: CaptureSessionHandling,
        qrPointScanningHandler: QRPointScanningHandling,
        presentationHandler: PresentationHandling,
        externalAppLauncher: ExternalAppLaunching,
        authorizationStatusProvider: CaptureAuthorizationStatusProviding,
        authorizationRequester: CaptureAuthorizationRequesting
    ) {
        self.captureSessionHandler = captureSessionHandler
        self.qrPointScanningHandler = qrPointScanningHandler
        self.presentationHandler = presentationHandler
        self.externalAppLauncher = externalAppLauncher
        self.authorizationStatusProvider = authorizationStatusProvider
        self.authorizationRequester = authorizationRequester
        super.init(nibName: nil, bundle: nil)

        self.captureSessionHandler.delegate = self
        self.qrPointScanningHandler.delegate = self
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSideTapViewHandler()

        captureSessionHandler.handleViewDidLoad(view)
        qrPointScanningHandler.handleViewDidLoad(view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        captureSessionHandler.handleViewWillAppear(view)

        updateUI()

        UIView.animate(withDuration: Self.fadeInAnimationLength, delay: 0, options: .curveEaseIn, animations: {
            self.view.alpha = 1.0
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        resetAuthorizationCaptureSessionError()

        captureSessionHandler.handleViewWillDisappear(view)

        UIView.animate(withDuration: Self.fadeOutAnimationLength, animations: {
            self.view.alpha = 0
        })
    }

    private func updateUI() {
        if let captureSessionError = captureSessionError {

            switch captureSessionError {
                case .captureNotAuthorized:
                    handleSessionUnauthorized()
                case .metadataOutputUnavailable, .videoInputUnavailable:
                    #if DEBUG
                        handleDebugSession()
                    #else
                        handleSessionFailed()
                    #endif
            }
        } else {

            resetScanningUI()
        }
    }

    private func handleSessionFailed() {
        screenView?.configureBottomOverlay(
            for: .fail(text: "Sorry bro, no way to run the app on this bad boi. :C \n(device unsupported)")
        )
    }

    private func handleSessionUnauthorized() {
        let buttonText: String
        let buttonTapHandler: () -> Void
        if authorizationStatusProvider.videoCaptureAuthorizationStatus == .notDetermined {
            buttonText = "Allow access"
            buttonTapHandler = { [weak self] in
                self?.requestVideoAccess()
            }
        } else {
            buttonText = "Open Settings"
            buttonTapHandler = { [weak self] in
                self?.externalAppLauncher.launchSettings(completion: nil)
            }
        }

        screenView?.configureBottomOverlay(
            for: .neutral(text: "Please allow the app to access camera to enable the QR Scanner."),
            buttonConfiguration: .init(text: buttonText, tapHandler: buttonTapHandler)
        )
    }

    private func resetAuthorizationCaptureSessionError() {

        if case .captureNotAuthorized = captureSessionError {
            captureSessionError = nil
        }
    }

    private func resetScanningUI() {
        screenView?.reset()
        scannedValueCodeObjectBounds = nil

        screenView?.configureBottomOverlay(
            for: .neutral(text: "Aim at Smart University Point QR code or skip to munimap.")
        )
    }

    private func setupSideTapViewHandler() {
        guard let screenView = screenView else { return }

        screenView.navigateToMunimapSideTapView.tapHandler = { [weak self] in
            guard let self = self else { return }

            self.delegate?.qrScannerViewController(self, didSelectContinueWith: nil)
        }
    }

    private func requestVideoAccess() {
        authorizationRequester.requestAccessForVideo { granted in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                if granted {
                    self.captureSessionHandler.handleViewWillAppear(self.view)
                    self.resetScanningUI()
                } else {
                    self.handleSessionUnauthorized()
                }
            }
        }
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

        screenView?.configureBottomOverlay(
            for: .neutral(text: "QR Point scanned, fetching data...")
        )

        scannedValueCodeObjectBounds = (outputString, objectBounds)
        qrPointScanningHandler.qrCodeValueScanned(outputString)
    }

    func captureSessionHandler(_ handler: CaptureSessionHandling, didTriggerError error: CaptureSessionError) {
        captureSessionError = error
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

        screenView?.hideMunimapSideTapView()
        screenView?.configureBottomOverlay(
            for: .success(text: "QR Point data scanned! Tap the button bellow when ready..."),
            buttonConfiguration: .init(
                text: "Proceed",
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
        showFailBottomOverlay(withText: "Cannot fetch QR Point data for scanned code.")
    }

    private func showFailBottomOverlay(withText text: String) {
        screenView?.hideBlurOverlay()

        let hideOverlayHandler: () -> Void = { [weak self] in
            self?.resetScanningUI()
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

        screenView?.hideMunimapSideTapView()
        screenView?.configureBottomOverlay(
            for: .success(text: "Debug session, eh? Enjoy..."),
            buttonConfiguration: .init(text: "Proceed", tapHandler: continueTapHandler)
        )
    }
    #endif

}
