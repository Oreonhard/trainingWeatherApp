//
//  WeatherTabBar.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2020/10/07.
//  Copyright © 2020 최준찬. All rights reserved.
//

import UIKit

class WeatherTabBar: UITabBarController {
    
    @IBInspectable var defaultIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
}
