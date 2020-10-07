//
//  TodayWeather.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2020/09/25.
//  Copyright © 2020 최준찬. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TodayWeather: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue : CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("Locatoin Coordinate : \(locationValue.longitude) \(locationValue.latitude)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    }
}
