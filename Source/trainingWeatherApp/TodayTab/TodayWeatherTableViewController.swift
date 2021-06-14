//
//  TodayWeatherTableViewController.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2021/03/20.
//  Copyright © 2021 최준찬. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class TodayWeatherTableViewController: UITableViewController {
    
    //MARK: Today View IBOutlet
    @IBOutlet weak var todayView : UIView!
    @IBOutlet weak var weatherStatus : UILabel!
    @IBOutlet weak var areaName : UILabel!
    @IBOutlet weak var temperature : UILabel!
    @IBOutlet weak var weatherIcon : UIImageView!
    @IBOutlet weak var loadingIndicator : UIActivityIndicatorView!
    
    //MARK: Global Variable
    let locationManager = CLLocationManager()
    var hourWeatherCollectionView : UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.locationManager.delegate = self
        
        let nibCell = UINib(nibName: "TimeWeatherTableViewCell", bundle: nil)
        self.tableView.register(nibCell, forCellReuseIdentifier: "timeWeatherTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let s_areaName = UserDefaults.standard.string(forKey: "areaName"), let currentDic = UserDefaults.standard.dictionary(forKey: "currentDic") {
            let weatherDic = (currentDic["weather"] as! NSArray)[0] as! [String:Any]
            areaName.text = s_areaName
            weatherStatus.text = weatherDic["description"] as? String
            temperature.text = currentDic["temp"] as? String ?? "ERROR"
            weatherIcon.image = self.getWeatherIcon(weatherID: weatherDic["id"] as? Int ?? 800)
        }

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "timeWeatherTableViewCell") as! TimeWeatherTableViewCell
            let cellNib = UINib(nibName: "CollectionViewCell", bundle: nil)
            
            hourWeatherCollectionView = customCell.timeWeatherCollectionView
            
            hourWeatherCollectionView!.register(cellNib, forCellWithReuseIdentifier: "hourCollectionCell")
            hourWeatherCollectionView!.delegate = self
            hourWeatherCollectionView!.dataSource = self
            
            return customCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weekWeatherCell") as! WeekTableViewCell
            if let dailyArr = UserDefaults.standard.array(forKey: "dailyArr") {
                let dailyDic = dailyArr[indexPath.row-1] as! [String:Any]
                
                cell.dayLabel.text = Date(timeIntervalSince1970: dailyDic["dt"] as! TimeInterval).toString(dateFormat: "eeee")
                cell.weekWeatherIcon.image = getWeatherIcon(weatherID: ((dailyDic["weather"] as! NSArray)[0] as! [String:Any])["id"] as? Int ?? 800)
                cell.weekHighTemp.text = String(format: "%.0f", round((dailyDic["temp"] as! [String:Double])["max"] ?? 0))
                cell.weekLowerTemp.text = String(format: "%.0f", round((dailyDic["temp"] as! [String:Double])["min"] ?? 0))
                
                return cell
            } else {
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 128
        }
        return 60
    }
    
    func getWeatherIcon(weatherID: Int) -> UIImage {
        switch WeatherStatusGet(weatherID: weatherID) {
        case .Clear:
            return #imageLiteral(resourceName: "sun")
        case .Clouds:
            return #imageLiteral(resourceName: "cloudy")
        case .Rain:
            return #imageLiteral(resourceName: "rainy")
        case .Drizzle:
            return #imageLiteral(resourceName: "rain")
        case .Thunder:
            return #imageLiteral(resourceName: "thunder")
        case .Snow:
            return #imageLiteral(resourceName: "snowy")
        case .Atmosphere:
            return #imageLiteral(resourceName: "mist")
        }
    }

    //MARK: IBAction
    @IBAction func reloadWeather(_ sender: Any) {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            loadingIndicator.startAnimating()
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

extension TodayWeatherTableViewController : CLLocationManagerDelegate {
    
    //MARK: 위치(GPS) 관련 Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            loadingIndicator.startAnimating()
            self.locationManager.requestLocation()
        case .restricted , .denied :
            areaName.text = "위치 조회에 실패하였습니다."
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue : CLLocationCoordinate2D = manager.location?.coordinate
        else {
            loadingIndicator.stopAnimating()
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(.init(latitude: locationValue.latitude, longitude: locationValue.longitude), completionHandler: { (placeMarks, _) -> Void in
            placeMarks?.forEach({ (placeMark) in
                if let city = placeMark.locality ?? placeMark.name {
                    self.areaName.text = city
                    UserDefaults.standard.setValue(city, forKey: "areaName")
                } else {
                    self.areaName.text = "위치 조회에 실패하였습니다."
                }
            })
        })
        
        let URL = "https://api.openweathermap.org/data/2.5/onecall?lat=\(locationValue.latitude)&lon=\(locationValue.longitude)&exclude=minutely,alerts&appid=\("weatherAPI_Key".localized)&units=\(UserDefaults.standard.bool(forKey: "isFahrenheit") ? "imperial" : "metric")&lang=\(Locale.current.regionCode?.lowercased() ?? "base_Lang".localized)"
        AF.request(URL) .responseJSON() { response in
            switch response.result {
            case .success:
                if let result = try! response.result.get() as? [String:Any] {
                    
                    var currentDic = result["current"] as! [String:Any]
                    currentDic["temp"] = "\(String(format: "%.0f", round(currentDic["temp"] as? Double ?? 0.0)))\(UserDefaults.standard.bool(forKey: "isFahrenheit") ? "°F" : "°C")"
                    
                    UserDefaults.standard.setValue(currentDic, forKey: "currentDic")
                    UserDefaults.standard.setValue(result["daily"] as! NSArray, forKey: "dailyArr")
                    UserDefaults.standard.setValue(result["hourly"] as! NSArray, forKey: "hourlyArr")
                    
                    self.hourWeatherCollectionView?.reloadData()
                    self.tableView.reloadData()
                    
                    let weatherDic = (currentDic["weather"] as! NSArray)[0] as! [String:Any]
                    self.weatherStatus.text = weatherDic["description"] as? String
                    self.temperature.text = currentDic["temp"] as? String ?? "ERROR"
                    self.weatherIcon.image = self.getWeatherIcon(weatherID: weatherDic["id"] as? Int ?? 800)
                    
                }
            case .failure(let error):
                print(error)
            }
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager did Fail : \(error.localizedDescription)")
    }
}

extension TodayWeatherTableViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let hourlyArr = UserDefaults.standard.array(forKey: "hourlyArr") {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCollectionCell", for: indexPath) as! CollectionViewCell
            let hourlyDic = hourlyArr[indexPath.row] as! [String:Any]
            cell.time.text = Date(timeIntervalSince1970: hourlyDic["dt"] as! TimeInterval).toString(dateFormat: "HH:mm")
            cell.weatherIcon.image = getWeatherIcon(weatherID: (((hourlyDic["weather"] as! NSArray)[0]) as! [String:Any])["id"] as? Int ?? 800)
            cell.temperature.text = "\(String(format: "%.0f", round(hourlyDic["temp"] as? Double ?? 0.0)))\(UserDefaults.standard.bool(forKey: "isFahrenheit") ? "°F" : "°C")"
            
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "hourCollectionCell", for: indexPath)
        }
    }
}
