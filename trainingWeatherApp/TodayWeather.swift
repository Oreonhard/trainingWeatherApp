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
import Alamofire

class TodayWeather: UIViewController {
    
    //MARK: UI Variable
    @IBOutlet weak var TodayView: UIView!
    @IBOutlet weak var Weather: UILabel!
    @IBOutlet weak var AreaName: UILabel!
    @IBOutlet weak var Temperature: UILabel!
    @IBOutlet weak var WeatherIcon: UIImageView!
    
    @IBOutlet weak var HourWeather: UICollectionView!
    
    @IBOutlet weak var WeekWeather: UITableView!
    
    //MARK: Constraint Variable
    @IBOutlet weak var TodayViewHeight: NSLayoutConstraint!
    
    //MARK: Global Variable
    let locationManager = CLLocationManager();
    var TodayViewMaxHeight : CGFloat = 0.0
    var TodayViewMinHeight : CGFloat = 0.0
    var activityIndicator : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.HourWeather.delegate = self
        self.HourWeather.dataSource = self
        self.WeekWeather.delegate = self
        self.WeekWeather.dataSource = self
        
        self.locationManager.requestAlwaysAuthorization()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        TodayViewMaxHeight = TodayView.frame.height
        let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
        TodayViewMinHeight = safeAreaHeight * 0.6
    }
    
    @IBAction func reloadLocation(_ sender: Any) {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            activityIndicator = UIAlertController(title: "위치 조회 중...", message: nil, preferredStyle: .alert)
            activityIndicator?.addIndicator()
            present(activityIndicator!, animated: true, completion: {
                self.locationManager.requestLocation()
            })
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
    
    func changeWeatherIcon(weatherID: Int) {
        switch WeatherStatusGet(weatherID: weatherID) {
        case .Clear:
            WeatherIcon.image = #imageLiteral(resourceName: "sun")
        case .Clouds:
            WeatherIcon.image = #imageLiteral(resourceName: "cloudy")
        case .Rain:
            WeatherIcon.image = #imageLiteral(resourceName: "rainy")
        case .Drizzle:
            WeatherIcon.image = #imageLiteral(resourceName: "rain")
        case .Thunder:
            WeatherIcon.image = #imageLiteral(resourceName: "thunder")
        case .Snow:
            WeatherIcon.image = #imageLiteral(resourceName: "snowy")
        case .Atmosphere:
            WeatherIcon.image = #imageLiteral(resourceName: "mist")
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
        guard let locationValue : CLLocationCoordinate2D = manager.location?.coordinate
        else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let URL = "https://api.openweathermap.org/data/2.5/weather?lat=\(locationValue.latitude)&lon=\(locationValue.longitude)&appid=\("weatherAPI_Key".localized)&units=metric&lang=\("base_Lang".localized)"
        AF.request(URL) .responseJSON() { response in
            switch response.result {
            case .success:
                if let result = try! response.result.get() as? [String:Any] {
                    let main = result["main"] as! [String:Any]
                    let weather = (result["weather"] as! NSArray)[0] as! [String:Any]
                    
                    self.AreaName.text = result["name"] as? String
                    self.Temperature.text = "\(String(format: "%.0f", round(main["temp"] as? Double ?? 0.0)))°C"
                    self.Weather.text = weather["description"] as? String
                    self.changeWeatherIcon(weatherID: weather["id"] as? Int ?? 800)
                }
            case .failure(let error):
                print(error)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager did Fail : \(error.localizedDescription)")
    }
}

extension TodayWeather: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCollectionCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: HourWeather.frame.height)
    }
}

extension TodayWeather: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayTableCell", for: indexPath)
        
        return cell
    }
}

extension TodayWeather: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("Start Drag")
    }
}
