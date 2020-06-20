//
//  ARMapPageViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 13/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

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

    let arViewController: UIViewController
    let muniMapViewController: UIViewController

    init(arViewController: UIViewController, muniMapViewController: UIViewController) {
        self.arViewController = arViewController
        self.muniMapViewController = muniMapViewController

        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSideTapViewHandlers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setViewControllers([muniMapViewController], direction: .forward, animated: true)
    }

    private func setupSideTapViewHandlers() {
        guard let screenOverlayView = screenOverlayView else { return }

        screenOverlayView.navigateBackSideTapView.tapHandler = { [weak self] in
            guard let self = self else { return }

            self.didFinishHandler?()
        }

        screenOverlayView.munimapSideTapView.tapHandler = { [weak self] in
            guard let self = self else { return }

            self.switchTo(self.muniMapViewController, direction: .reverse)
        }

        screenOverlayView.arViewSideTapView.tapHandler = { [weak self] in
            guard let self = self else { return }

            self.switchTo(self.arViewController, direction: .forward)
        }
    }

    private func switchTo(_ viewController: UIViewController, direction: UIPageViewController.NavigationDirection) {
        guard viewControllers?.contains(viewController) == false else { return }

        setViewControllers([viewController], direction: direction, animated: true)
    }
}
