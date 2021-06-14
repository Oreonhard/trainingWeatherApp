//
//  RegionWeatherTableViewCell.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2021/04/18.
//  Copyright © 2021 최준찬. All rights reserved.
//

import UIKit

class RegionWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var regionName : UILabel!
    @IBOutlet weak var regionTemperature : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
