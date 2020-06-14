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

    let arViewController: UIViewController
    let muniMapViewController: UIViewController

    init(arViewController: UIViewController, muniMapViewController: UIViewController) {
        self.arViewController = arViewController
        self.muniMapViewController = muniMapViewController

        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setViewControllers([muniMapViewController], direction: .forward, animated: true)
    }
}
