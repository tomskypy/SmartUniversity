//
//  CaptureSessionHandling.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

protocol CaptureSessionHandling {

    var delegate: CaptureSessionHandlerDelegate? { get set }

    func handleViewDidLoad(_ view: UIView)
    func handleViewWillAppear(_ view: UIView)
    func handleViewWillDisappear(_ view: UIView)
}
