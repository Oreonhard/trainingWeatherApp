//
//  Extension.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2021/02/18.
//  Copyright © 2021 최준찬. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}
