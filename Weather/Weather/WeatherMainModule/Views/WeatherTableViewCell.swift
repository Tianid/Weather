//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Tianid on 29.10.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
     @IBOutlet weak var dayOfWeekLabel: UILabel!
     @IBOutlet weak var degreesLabel: UILabel!
     @IBOutlet weak var weatherImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
