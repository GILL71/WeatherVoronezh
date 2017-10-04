//
//  ForecastViewController.swift
//  WeatherVoronezh
//
//  Created by Михаил Нечаев on 19.09.17.
//  Copyright © 2017 Михаил Нечаев. All rights reserved.
//

import UIKit
import CoreData

class ForecastViewController: UITableViewController {

    let client = ApiClient()
    let coreData = DataSource()
    var forecasts = [Forecast]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var city = ""
    var locationManager: CustomLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecasts = coreData.getData()
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        self.navigationItem.title = "Погода" + "\(city)"
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherDayId", for: indexPath) as! OtherForecastCell
        cell.fillWith(forecasts[indexPath.row])
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red:0.58, green:0.79, blue:0.91, alpha:1.0)
        } else {
            cell.backgroundColor = UIColor(red:0.73, green:0.78, blue:0.81, alpha:1.0)
        }
        return cell
    }
 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? InfoController {
            let forecast = forecasts[(self.tableView.indexPathForSelectedRow?.row)!]
            let forecastStruct = ForecastStruct(date: forecast.date!,
                                                high: forecast.high,
                                                low: forecast.low,
                                                text: forecast.text!)
            destinationViewController.forecast = forecastStruct
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        locationManager = CustomLocationManager()
        city = locationManager.city
        client.requestData(locationName: city)
        self.navigationItem.title = "Погода" + "\(city)"
        forecasts = coreData.getData()
        refreshControl.endRefreshing()
    }
}
