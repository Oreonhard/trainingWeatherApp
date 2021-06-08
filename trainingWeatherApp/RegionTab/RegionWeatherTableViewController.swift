//
//  ViewController.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2020/09/02.
//  Copyright © 2020 최준찬. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class RegionWeatherTableViewController: UITableViewController {
    
    private var regionInfoArr : [[String:Any]] = (UserDefaults.standard.array(forKey: "regionInfos") ?? []) as! [[String:Any]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectRegion(_:)), name: .init("selectRegion"), object: nil)
        
        for i in 0 ..< regionInfoArr.count {
            let lat = regionInfoArr[i]["regionLat"] as! Double
            let lon = regionInfoArr[i]["regionLon"] as! Double
            
            CLGeocoder().reverseGeocodeLocation(.init(latitude: lat, longitude: lon), completionHandler: { (placeMarks, _) -> Void in
                placeMarks?.forEach({ (placeMark) in
                    if let city = placeMark.locality ?? placeMark.name {
                        self.regionInfoArr[i]["regionName"] = city
                        print(i," ",city)
                    } else {
                        self.regionInfoArr[i]["regionName"] = "Error"
                    }
                })
            })
            
            let URL = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\("weatherAPI_Key".localized)"
            AF.request(URL).responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    if let result = try! response.result.get() as? [String:Any] {
                        self.regionInfoArr[i]["temperature"] = "\(String(format: "%.0f", round((result["main"] as! [String:Any])["temp"] as! Double)))°C"
                    }
                case .failure(let error):
                    print(error)
                }
                UserDefaults.standard.setValue(self.regionInfoArr, forKey: "regionInfos")
                self.tableView.reloadData()
            })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regionInfoArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "regionWeatherCell") as! RegionWeatherTableViewCell
        cell.regionName.text = regionInfoArr[indexPath.row]["regionName"] as? String
        cell.regionTemperature.text = regionInfoArr[indexPath.row]["temperature"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            regionInfoArr.remove(at: indexPath.row)
            UserDefaults.standard.setValue(regionInfoArr, forKey: "regionInfos")
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "presentRegionWeather", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? PresentWeatherTableViewController else { return }
        print("Segue!")
        
        let index = sender as! Int
        vc.regionLon = regionInfoArr[index]["regionLon"] as? Double
        vc.regionLat = regionInfoArr[index]["regionLat"] as? Double
        vc.p_areaName = regionInfoArr[index]["regionName"] as? String
    }
    
    @objc func selectRegion(_ noti: Notification) {
        self.navigationItem.searchController?.searchBar.text = ""
        
        let placeMark = noti.object as! MKPlacemark
        
        let URL = "https://api.openweathermap.org/data/2.5/weather?lat=\(placeMark.coordinate.latitude)&lon=\(placeMark.coordinate.longitude)&units=metric&appid=\("weatherAPI_Key".localized)"
        AF.request(URL).responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                if let result = try! response.result.get() as? [String:Any] {
                    let temperature = "\(String(format: "%.0f", round((result["main"] as! [String:Any])["temp"] as! Double)))°C"
                    let regionTemp : [String:Any] = ["regionName" : placeMark.locality ?? placeMark.name, "regionLat": Double(placeMark.coordinate.latitude), "regionLon": Double(placeMark.coordinate.longitude), "temperature":temperature]
                    self.regionInfoArr.append(regionTemp)
                    UserDefaults.standard.setValue(self.regionInfoArr, forKey: "regionInfos")
                    
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func setNavBar() {
        let searchResultController = SearchResultTableViewController()
        let regionSearchController = UISearchController(searchResultsController: searchResultController)
        regionSearchController.searchResultsUpdater = searchResultController
        
        self.navigationItem.searchController = regionSearchController
        self.navigationItem.title = "지역별 날씨"
    }
}
