//
//  Extension.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2021/02/18.
//  Copyright © 2021 최준찬. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}

extension UIAlertController {
    func addIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        self.view.heightAnchor.constraint(equalToConstant: 95).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
    }
}
