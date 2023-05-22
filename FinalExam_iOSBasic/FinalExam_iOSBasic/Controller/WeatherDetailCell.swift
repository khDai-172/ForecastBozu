//
//  WeatherDetailCell.swift
//  FinalExam_iOSBasic
//
//  Created by Khoa Dai on 27/02/2023.
//

import UIKit

class WeatherDetailCell: UITableViewCell {
    @IBOutlet weak var iconCell: UIImageView!
    @IBOutlet weak var tempCell: UILabel!
    @IBOutlet weak var conditCell: UILabel!
    @IBOutlet weak var timeCell: UILabel!
    var forecastDataCell: ClassList? {
        didSet {
            guard let forecastCell = forecastDataCell else {
                return
            }
            if let iconBadge = forecastCell.weather[0].icon {
                iconCell.image = UIImage(named: iconBadge)
                tempCell.text = "\(Int(forecastCell.main.temp ?? 0.0))°C"
                conditCell.text = forecastCell.weather[0].description
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
