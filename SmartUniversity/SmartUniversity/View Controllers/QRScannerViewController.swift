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

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

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

        screenView?.blurredOverlayView.isHidden = true
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
        view.layer.sublayers?.insert(previewLayer, at: 0)
    }

    func captureSessionHandler(
        _ handler: CaptureSessionHandler,
        didReceiveValidOutput outputString: String,
        fromObjectWithBounds objectBounds: CGRect
    ) {
        guard let blurredOverlayView = screenView?.blurredOverlayView else { return }

        blurredOverlayView.layer.mask = createShapeMask(bounds: objectBounds)

        if blurredOverlayView.isHidden {
            blurredOverlayView.isHidden = false
        }
    }

    func captureSessionHandler(_ handler: CaptureSessionHandler, didTriggerError error: CaptureSessionError) {
        handleSessionFailed()
    }

    private func createShapeMask(bounds: CGRect) -> CALayer { // TODO refactor elsewhere
        let shapeLineWidth: CGFloat = 10

        let scanLayer = CAShapeLayer()

        let outerPath = UIBezierPath(rect: bounds)

        let superlayerPath = UIBezierPath.init(rect:
            CGRect(
                x: max(0, bounds.minX - shapeLineWidth),
                y: max(0, bounds.minY - shapeLineWidth),
                width: bounds.width + shapeLineWidth * 2,
                height: bounds.height + shapeLineWidth * 2
            )
        )
        outerPath.usesEvenOddFillRule = true
        outerPath.append(superlayerPath)
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = CAShapeLayerFillRule.evenOdd
        scanLayer.fillColor = UIColor.black.cgColor

        return scanLayer
    }
}
