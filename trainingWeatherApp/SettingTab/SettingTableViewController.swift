//
//  SettingTableViewController.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2021/06/14.
//  Copyright © 2021 최준찬. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    //MARK: Setting View IBOutlet
    @IBOutlet weak var notation: UISegmentedControl!
    @IBOutlet weak var appLang: UILabel!
    @IBOutlet weak var appVer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appLang.text =  Locale.current.regionCode ?? "base_Lang".localized
        appVer.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        if UserDefaults.standard.bool(forKey: "isFahrenheit") {
            notation.selectedSegmentIndex = 1
        } else {
            notation.selectedSegmentIndex = 0
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    @IBAction func notationChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { UserDefaults.standard.setValue(false, forKey: "isFahrenheit") }
        else { UserDefaults.standard.setValue(true, forKey: "isFahrenheit") }
    }
    
}
