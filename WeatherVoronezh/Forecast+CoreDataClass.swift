//
//  Forecast+CoreDataClass.swift
//  WeatherVoronezh
//
//  Created by Михаил Нечаев on 20.09.17.
//  Copyright © 2017 Михаил Нечаев. All rights reserved.
//

import Foundation
import CoreData


public class Forecast: NSManagedObject {
    struct Attributes {
        static let date = "date"
        static let high = "high"
        static let low  = "low"
        static let text = "text"
    }
}

struct ForecastStruct {
    let date: NSDate
    let high: Int16
    let low: Int16
    let text: String
}

extension Forecast {
    convenience init(with forecast: ForecastStruct, and context: NSManagedObjectContext) {
        self.init(context: context)
        date = forecast.date
        high = forecast.high
        low = forecast.low
        text = forecast.text
    }
}

public struct WeatherCoreDataError: Error {
    enum Code: Int {
        case CreationError = -7000
        case ParsingError  = -7001
    }
    
    let errorCode: Code
}
