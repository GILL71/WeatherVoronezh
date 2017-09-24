//
//  ForecastCell.swift
//  WeatherVoronezh
//
//  Created by Михаил Нечаев on 21.09.17.
//  Copyright © 2017 Михаил Нечаев. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private let formatter: DateFormatter = {
        let myFormatter = DateFormatter()
        myFormatter.locale = Locale(identifier: "en_US_POSIX")
        myFormatter.dateFormat = "dd MMM yyyy"
        return myFormatter
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillWith(_ forecast: Forecast) {
        dateLabel.text = formatter.string(from: forecast.date! as Date)
        temperatureLabel.text = String("\((forecast.high + forecast.low) / 2)")
    }
}
