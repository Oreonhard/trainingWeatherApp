//
//  TimeWeatherTableViewCell.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2021/03/21.
//  Copyright © 2021 최준찬. All rights reserved.
//

import UIKit

class TimeWeatherTableViewCell: UITableViewCell {
    
    //MARK: IBOutlet
    @IBOutlet weak var timeWeatherCollectionView : UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
