//
//  InfoController.swift
//  WeatherVoronezh
//
//  Created by Михаил Нечаев on 21.09.17.
//  Copyright © 2017 Михаил Нечаев. All rights reserved.
//

import UIKit

class InfoController: UIViewController {
    
    var forecast: ForecastStruct?

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var highLabel: UILabel!
    @IBOutlet var lowLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    
    private let formatter: DateFormatter = {
        let myFormatter = DateFormatter()
        myFormatter.locale = Locale(identifier: "en_US_POSIX")
        myFormatter.dateFormat = "dd MMM yyyy"
        return myFormatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        guard let viewForecast = forecast else {
            print("nothing to view")
            return
        }
        dateLabel.text = formatter.string(from: viewForecast.date as Date)
        highLabel.text = String(viewForecast.high)
        lowLabel.text = String(viewForecast.low)
        infoLabel.text = String(viewForecast.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sky.jpg")!)
    }
}
