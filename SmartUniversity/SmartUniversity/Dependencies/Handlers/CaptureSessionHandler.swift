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

final class CaptureSessionHandler: NSObject, CaptureSessionHandling {

    static let shared = CaptureSessionHandler()

    weak var delegate: CaptureSessionHandlerDelegate?

    private(set) var captureSession: AVCaptureSession?
    private(set) var previewLayer: AVCaptureVideoPreviewLayer?

    private let deviceProvider: CaptureDeviceProviding
    private let sessionProvider: CaptureSessionProviding

    init(
        deviceProvider: CaptureDeviceProviding = CaptureDeviceProvider.shared,
        sessionProvider: CaptureSessionProviding = CaptureSessionProvider.shared
    ) {
        self.deviceProvider = deviceProvider
        self.sessionProvider = sessionProvider
    }

    func handleViewDidLoad(_ view: UIView) {
        let captureSession = sessionProvider.makeCaptureSession()

        guard let sessionInput = makeVideoDeviceInput(for: captureSession) else {
            delegate?.captureSessionHandler(self, didTriggerError: .videoInputUnavailable)
            return
        }
        captureSession.addInput(sessionInput)

        guard let sessionOutput = makeSessionMetadataOutput(for: captureSession) else {
            delegate?.captureSessionHandler(self, didTriggerError: .metadataOutputUnavailable)
            return
        }
        captureSession.addOutput(sessionOutput)

        self.previewLayer = makeVideoPreviewLayer(for: captureSession, captureView: view)
        self.captureSession = captureSession
    }

    private func makeVideoDeviceInput(for session: AVCaptureSession) -> AVCaptureDeviceInput? {

        guard let videoCaptureDevice = deviceProvider.videoCaptureDevice else { return nil }

        let captureDeviceInput: AVCaptureDeviceInput?
        do { captureDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice) }
        catch { return nil }

        if let videoInput = captureDeviceInput, session.canAddInput(videoInput) { return videoInput }
        else { return nil }
    }

    private func makeSessionMetadataOutput(for session: AVCaptureSession) -> AVCaptureMetadataOutput? {

        let metadataOutput = AVCaptureMetadataOutput()
        guard session.canAddOutput(metadataOutput) else { return nil }

        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        return metadataOutput
    }

    private func makeVideoPreviewLayer(
        for session: AVCaptureSession,
        captureView: UIView
    ) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = captureView.layer.bounds

        return previewLayer
    }
}

extension CaptureSessionHandler: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // TODO implement
    }
}
