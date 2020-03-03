//
//  BaseScreenView.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 03/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol BaseScreenView: UIView {

    func setupSubviews()
}

extension BaseScreenView {

    init() {
        self.init()
        setupSubviews()
    }
}
