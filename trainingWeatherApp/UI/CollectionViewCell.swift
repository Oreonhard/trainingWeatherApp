//
//  CollectionViewCell.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2021/03/20.
//  Copyright © 2021 최준찬. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    //MARK: IBOutlet
    @IBOutlet weak var time : UILabel!
    @IBOutlet weak var weatherIcon : UIImageView!
    @IBOutlet weak var temperature : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
