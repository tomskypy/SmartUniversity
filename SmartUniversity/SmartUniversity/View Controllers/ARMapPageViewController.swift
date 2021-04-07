//
//  ARMapPageViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 13/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit
import BaseAppCoordination

class BasePageViewController<ScreenView: BaseScreenView>: UIPageViewController {

    var screenOverlayView: ScreenView?

    override func loadView() {
        super.loadView()

        screenOverlayView = {
            let overlayView = ScreenView()
            overlayView.setupSubviews()
            overlayView.frame = view.bounds
            view.addSubview(overlayView)
            return overlayView
        }()
    }
}

final class ARMapPageViewController: BasePageViewController<ARMapPageScreenView> {

    var didFinishHandler: (() -> Void)?

    let arViewController: UIViewController?
    let muniMapViewController: UIViewController

    init(arViewController: UIViewController?, muniMapViewController: UIViewController) {
        self.arViewController = arViewController
        self.muniMapViewController = muniMapViewController

        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSideTapViewHandlers()

        setViewControllers([muniMapViewController], direction: .forward, animated: false)

        if let screenOverlayView = screenOverlayView {
            screenOverlayView.highlightTapView(screenOverlayView.munimapCornerTapView)
        }
    }

    private func setupSideTapViewHandlers() {
        guard let screenOverlayView = screenOverlayView else { return }

        screenOverlayView.navigateBackSideTapView.tapHandler = { [weak self] in
            guard let self = self else { return }

            self.didFinishHandler?()
        }

        let munimapTapView = screenOverlayView.munimapCornerTapView
        munimapTapView.tapHandler = { [weak self] in
            guard let self = self else { return }

            self.switchTo(self.muniMapViewController, direction: .reverse)
            self.screenOverlayView?.highlightTapView(munimapTapView)
        }

        let arViewTapView = screenOverlayView.arViewCornerTapView
        if let arViewController = arViewController {
            arViewTapView.tapHandler = { [weak self] in
                guard let self = self else { return }

                self.switchTo(arViewController, direction: .forward)
                self.screenOverlayView?.highlightTapView(arViewTapView)
            }
        } else {
            arViewTapView.isHidden = true
        }
    }

    private func switchTo(_ viewController: UIViewController, direction: UIPageViewController.NavigationDirection) {
        guard viewControllers?.contains(viewController) == false else { return }

        setViewControllers([viewController], direction: direction, animated: true)
    }
}
