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
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue : CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("Locatoin Coordinate : \(locationValue.longitude) \(locationValue.latitude)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // iOS 14 이상부터 지원 가능 > 현재 개발 중인 앱 지원 범위는 iOS 12 이상
        print("locationManagerDidChangeAuthorization Work")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       print(status)
    }
}
