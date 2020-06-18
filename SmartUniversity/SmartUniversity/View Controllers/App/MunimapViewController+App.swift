//
//  MunimapViewController+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

extension MunimapViewController {

    convenience init() {
        self.init(munimapServerURL: AppURL.munimap.value, webViewHandler: WebViewHandler())
    }
}
