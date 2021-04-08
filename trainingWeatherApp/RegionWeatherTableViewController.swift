//
//  ViewController.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2020/09/02.
//  Copyright © 2020 최준찬. All rights reserved.
//

import UIKit

class RegionWeatherTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "regionWeatherCell")!
    }
}

