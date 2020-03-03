//
//  BaseViewController.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

class BaseViewController<ScreenView: BaseScreenView>: UIViewController {

    var screenView: ScreenView? {
        return view as? ScreenView
    }

    override func loadView() {
        view = ScreenView()
        screenView?.setupSubviews()
    }
}
