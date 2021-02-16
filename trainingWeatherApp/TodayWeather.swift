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

class TodayWeather: UIViewController {
    
    //MARK: UI Variable
    @IBOutlet weak var AreaName: UILabel!
    
    //MARK: Global Variable
    let locationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }
    
    
    @IBAction func reloadLocation(_ sender: Any) {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.requestLocation()
        case .denied:
            let alertCon = UIAlertController(title:"trainingWeatherApp", message: "위치 권한이 거부되어 있습니다.\n 앱 설정에서 권한을 허용해주세요.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                if #available(iOS 13, *){
                    if let settingUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingUrl){
                        UIApplication.shared.open(settingUrl, completionHandler: {
                            success in
                            print("Open Setting : \(success)")
                        })
                    }
                }
            })
            alertCon.addAction(alertAction)
            self.present(alertCon, animated: true, completion: nil)
        default:
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
}

extension TodayWeather : CLLocationManagerDelegate {
    
    //MARK: 위치(GPS) 관련 Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.requestLocation()
        default:
            AreaName.text = "위치 조회에 실패하였습니다."
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue : CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("Location Coordinate : \(locationValue.longitude) \(locationValue.latitude)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager did Fail : \(error.localizedDescription)")
    }
}
