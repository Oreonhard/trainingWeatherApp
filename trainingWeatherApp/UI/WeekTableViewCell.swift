//
//  WeekTableViewCell.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2021/03/23.
//  Copyright © 2021 최준찬. All rights reserved.
//

import UIKit

class WeekTableViewCell: UITableViewCell {
    //MARK: IBOutlet
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekWeatherIcon: UIImageView!
    @IBOutlet weak var weekHighTemp: UILabel!
    @IBOutlet weak var weekLowerTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
