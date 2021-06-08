//
//  PresentWeatherTableViewController.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2021/03/20.
//  Copyright © 2021 최준찬. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class PresentWeatherTableViewController: UITableViewController {
    
    //MARK: Today View IBOutlet
    @IBOutlet weak var todayView : UIView!
    @IBOutlet weak var weatherStatus : UILabel!
    @IBOutlet weak var areaName : UILabel!
    @IBOutlet weak var temperature : UILabel!
    @IBOutlet weak var weatherIcon : UIImageView!
    
    //MARK: Global Variable
    var hourWeatherCollectionView : UICollectionView?
    var activityIndicator : UIAlertController = UIAlertController(title: "조회 중...", message: nil, preferredStyle: .alert)
    var regionLon : CLLocationDegrees?
    var regionLat : CLLocationDegrees?
    var dailyArr : NSArray?
    var hourlyArr : NSArray?
    var p_areaName : String?
    var firstViewAppear = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.addIndicator()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibCell = UINib(nibName: "TimeWeatherTableViewCell", bundle: nil)
        self.tableView.register(nibCell, forCellReuseIdentifier: "timeWeatherTableVIewCell")
        
        if let name = p_areaName { self.areaName.text = name }
        else { self.areaName.text = "ERROR" }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstViewAppear {
            present(activityIndicator, animated: true, completion: {
                self.getWeather()
            })
            firstViewAppear = false
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
            let customCell = tableView.dequeueReusableCell(withIdentifier: "timeWeatherTableVIewCell") as! TimeWeatherTableViewCell
            let cellNib = UINib(nibName: "CollectionViewCell", bundle: nil)
            
            hourWeatherCollectionView = customCell.timeWeatherCollectionView
            
            hourWeatherCollectionView!.register(cellNib, forCellWithReuseIdentifier: "hourCollectionCell")
            hourWeatherCollectionView!.delegate = self
            hourWeatherCollectionView!.dataSource = self
            
            return customCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weekWeatherCell") as! WeekTableViewCell
            if let dailyArr = dailyArr {
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
        present(activityIndicator, animated: true, completion: {
            self.getWeather()
        })
    }
    
    func getWeather() {
        guard let lat = regionLat, let lon = regionLon else {
            self.weatherStatus.text = "ERROR"
            self.temperature.text = "ERROR"
            self.areaName.text = "조회 중 오류가 발생했습니다."
            self.weatherIcon.image = self.getWeatherIcon(weatherID: 800)
            return
        }
        let URL = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,alerts&appid=\("weatherAPI_Key".localized)&units=metric&lang=\(Locale.current.regionCode?.lowercased() ?? "base_Lang".localized)"
        AF.request(URL) .responseJSON() { response in
            switch response.result {
            case .success:
                if let result = try! response.result.get() as? [String:Any] {
                    
                    let currentDic = result["current"] as! [String:Any]
                    self.dailyArr = result["daily"] as? NSArray
                    self.hourlyArr = result["hourly"] as? NSArray
                    
                    self.hourWeatherCollectionView?.reloadData()
                    self.tableView.reloadData()
                    
                    let weatherDic = (currentDic["weather"] as! NSArray)[0] as! [String:Any]
                    self.weatherStatus.text = weatherDic["description"] as? String
                    self.temperature.text = "\(String(format: "%.0f", round(currentDic["temp"] as? Double ?? 0.0)))°C"
                    self.weatherIcon.image = self.getWeatherIcon(weatherID: weatherDic["id"] as? Int ?? 800)
                    
                }
            case .failure(let error):
                print(error)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension PresentWeatherTableViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let hourlyArr = hourlyArr {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCollectionCell", for: indexPath) as! CollectionViewCell
            let hourlyDic = hourlyArr[indexPath.row] as! [String:Any]
            cell.time.text = Date(timeIntervalSince1970: hourlyDic["dt"] as! TimeInterval).toString(dateFormat: "HH:mm")
            cell.weatherIcon.image = getWeatherIcon(weatherID: (((hourlyDic["weather"] as! NSArray)[0]) as! [String:Any])["id"] as? Int ?? 800)
            cell.temperature.text = "\(String(format: "%.0f", round(hourlyDic["temp"] as? Double ?? 0.0)))°C"
            
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "hourCollectionCell", for: indexPath)
        }
    }
}
