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

    func makeViewControllerConfigurations() -> [OnboardingCoordinator.ViewControllerConfiguration]{
        [
        .init(
            titleText: "Wel-\ncome",
            bodyText: "... to the Smart University app!\n\nThanks for giving it a try, let us show you around."
        ),
        .init(
            titleText: "In-\ndoors",
            bodyText: "The main feature is a indoor localization within MUNI's faculties.\n\nWe cannot utilize the GPS indoors, so we've come up with QR Points."
        ),
        .init(
            titleText: "QR\nScan-\nner",
            bodyText: "The QR Scanner helps you access any QR Point.\n\nThose are posters with a QR code placed strategically around faculties.",
            action: { viewController in
                self.checkCameraPermissionAuthorization(within: viewController)
            }
        ),
        .init(
            titleText: "muni-\nmap",
            bodyText: "Powered by the QR Point's data, you'll be localized on the munimap*.\n\n*munimap - handy MUNI's interactive map of all rooms on all floors within any faculty"
        ),
        .init(
            titleText: "AR\nView",
            bodyText: "Last but hopefully not least there's AR View.\n\nLaunch it and aim the AR preview at the QR Point. Then, simply follow the instructions."
        ),
        .init(
            titleText: "Than-\nks",
            bodyText: "For going all the way through.\n\nWe'll try to condense this somehow in future versions."
        )
        ]
    }

    private func checkCameraPermissionAuthorization(within viewController: UIViewController) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted == false {
                    self.appHasToCloseAlertDialog(on: viewController)
                }
            }

        case .denied:
            grantCameraPermissionsInSettingsAlertDialog(on: viewController)

        case .restricted:
            fallthrough
        @unknown default:
            appHasToCloseAlertDialog(on: viewController)
        }
    }

    private func appHasToCloseAlertDialog(on viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Unsupported configuration",
            message: "Set configuration is unsupported, app has to close.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        viewController.present(alert, animated: true, completion: {
            exit(0) // FIXME: replace with alternative UX
        })
    }

    private func grantCameraPermissionsInSettingsAlertDialog(on viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Grant camera permissions",
            message: "Please grant camera permissions in the Settings by tapping the button.",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (_) -> Void in
            self.externalAppLauncher.launchSettings()
        }
        alert.addAction(settingsAction)
        viewController.present(alert, animated: true)
    }
}
