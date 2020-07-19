//
//  OnboardingCoordinator+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit
import AVFoundation

extension OnboardingCoordinator {

    convenience init(navigationController: NavigationController) {
        self.init(
            navigationController: navigationController,
            dependencies: .init(
                viewControllerConfigurations: AppOnboardingDependenciesFactory().makeViewControllerConfigurations()
            )
        )
    }
}

struct AppOnboardingDependenciesFactory {

    let externalAppLauncher: ExternalAppLaunching

    init(externalAppLauncher: ExternalAppLaunching = ExternalAppLauncher()) {
        self.externalAppLauncher = externalAppLauncher
    }

    func makeViewControllerConfigurations() -> [OnboardingCoordinator.ViewControllerConfiguration] {
        [
            .init(
                titleText: "Wel-\ncome",
                bodyText: "... to the Smart University app!\n\nThanks for giving it a try, let us show you around."
            ),
            .init(
                titleText: "In-\ndoors",
                bodyText: "The main feature is a indoor localization within MUNI's faculties.\n\nWe cannot utilize the"
                    + " GPS indoors, so we've come up with QR Points."
            ),
            .init(
                titleText: "QR\nScan-\nner",
                bodyText: "The QR Scanner helps you access any QR Point.\n\nThose are posters with a QR code placed"
                    + " strategically around faculties.",
                action: { self.checkCameraPermissionAuthorization(within: $0, completion: $1) }
            ),
            .init(
                titleText: "muni-\nmap",
                bodyText: "Powered by the QR Point's data, you'll be localized on the munimap*.\n\n*munimap - handy"
                    + " MUNI's interactive map of all rooms on all floors within any faculty"
            ),
            .init(
                titleText: "AR\nView",
                bodyText: "Lastly, there's AR View.\n\nLaunch it and aim the AR preview at the QR Point. Then, simply"
                    + " follow the instructions."
            ),
            .init(
                titleText: "Thank\nyou",
                bodyText: "... for going all the way through, that should be all the info you need.\n\nWe'll try to"
                    + " condense this somehow in future versions.",
                isFinal: true
            )
        ]
    }

    private func checkCameraPermissionAuthorization(
        within viewController: OnboardingViewController,
        completion: @escaping OnboardingViewController.ActionCompletion
    ) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:        AVCaptureDevice.requestAccess(for: .video) { _ in completion() }
            case .authorized:           return completion()
            case .denied, .restricted:  fallthrough
            @unknown default:           presentAllowCameraAccessInSettingsAlertDialog(
                on: viewController,
                completion: completion
            )
        }
    }

    private func presentAllowCameraAccessInSettingsAlertDialog(
        on viewController: OnboardingViewController,
        completion: @escaping OnboardingViewController.ActionCompletion
    ) {
        let alert = UIAlertController(
            title: "Allow camera access",
            message: "Please allow the app to access the camera in the Settings to enable QR Point scanning features.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            self.externalAppLauncher.launchSettings(completion: completion)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion()
        })

        viewController.present(alert, animated: true)
    }
}
