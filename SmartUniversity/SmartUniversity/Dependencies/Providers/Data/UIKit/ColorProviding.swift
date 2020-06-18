//
//  ColorProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol ColorProviding {

    var backgroundColor: UIColor { get }
    var overlayColor: UIColor { get }

    var textColor: UIColor { get }
}
