//
//  MainNavigationViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 16/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class MainNavigationViewController: UIPageViewController {

    override var viewControllers: [UIViewController] {
        [
            ARViewController()
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
    }
}

extension MainNavigationViewController: UIPageViewControllerDelegate {

}

extension MainNavigationViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        getNextViewController(after: false, currentViewController: viewController)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        getNextViewController(after: true, currentViewController: viewController)
    }

    private func getNextViewController(after: Bool, currentViewController: UIViewController) -> UIViewController {
        let indexChange = after ? 1 : -1
        let currentVCIndex = viewControllers.firstIndex(of: currentViewController) ?? 0
        let nextVCIndex = (currentVCIndex + indexChange) % viewControllers.count
        return viewControllers[nextVCIndex]
    }
}
