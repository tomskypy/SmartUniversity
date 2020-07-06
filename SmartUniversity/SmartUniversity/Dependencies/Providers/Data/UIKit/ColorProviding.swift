//
//  ColorProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol ColorProviding {

    var primaryColor: UIColor { get }
    var primaryDarkColor: UIColor { get }
    
    var secondaryColor: UIColor { get }

    var neutralColor: UIColor { get }
    var negativeColor: UIColor { get }

    var backgroundColor: UIColor { get }
    var overlayColor: UIColor { get }

    var textColor: UIColor { get }
    var buttonTextColor: UIColor { get }
}
