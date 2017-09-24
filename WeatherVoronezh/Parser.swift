//
//  Parser.swift
//  WeatherVoronezh
//
//  Created by Михаил Нечаев on 20.09.17.
//  Copyright © 2017 Михаил Нечаев. All rights reserved.
//

import Foundation
import CoreData

class Parser: NSObject {
    
    let coreData = DataSource()
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    func parse(withJson json: Any) throws -> [ForecastStruct] {
        let channel = try self.retreiveChannel(fromJson: json)
        let forecastsJson = try self.retreiveForecasts(fromChanelJson: channel)
        var forecasts = [ForecastStruct]()
        for forecastJson in forecastsJson {
            let forecast = try populateForecast(withJson: forecastJson)
            forecasts.append(forecast)
        }
        return forecasts
    }
    
    private func populateForecast(withJson json:Any) throws -> ForecastStruct {
        guard let jsonDictionary = json as? [String : Any] else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        guard let text = jsonDictionary["text"] as? String else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        guard let low = jsonDictionary["low"] as? String else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        guard let lowInt = Int16(low) else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        guard let high = jsonDictionary["high"] as? String else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        guard let highInt = Int16(high) else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        guard let dateString = jsonDictionary["date"] as? String else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        guard let date = Parser.formatter.date(from: dateString) else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        return ForecastStruct(date: date as NSDate, high: highInt, low: lowInt, text: text)
    }
    
    private func retreiveForecasts(fromChanelJson json:[String: Any]) throws -> [[String : String]] {
        guard let item = json["item"] as? [String: Any] else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        guard let forecastsArray = item["forecast"] as? [[String : String]] else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        return forecastsArray
    }
    
    private func retreiveChannel(fromJson json:Any) throws -> [String: Any] {
        guard let jsonDictionary = json as? [String: Any] else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        guard let queryJson = jsonDictionary["query"] as? [String: Any] else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        guard let resultsJson = queryJson["results"] as? [String: Any] else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        guard let channelJson = resultsJson["channel"] as? [String: Any] else {
            throw WeatherCoreDataError(errorCode: .ParsingError)
        }
        return channelJson
    }

}
