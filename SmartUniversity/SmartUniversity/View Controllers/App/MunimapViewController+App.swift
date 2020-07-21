//
//  MunimapViewController+App.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import UIKit

extension MunimapViewController {

    convenience init(focusedPlaceID: String?) {
        self.init(
            munimapServerURL: AppURL.munimap(placeID: focusedPlaceID).value,
            webViewHandler: WebViewHandler(),
            mapScaleProvider: MunimapScaleProvider(screenScale: UIScreen.main.scale)
        )
    }
}
