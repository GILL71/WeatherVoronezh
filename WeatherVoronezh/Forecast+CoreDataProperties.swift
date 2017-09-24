//
//  Forecast+CoreDataProperties.swift
//  WeatherVoronezh
//
//  Created by Михаил Нечаев on 20.09.17.
//  Copyright © 2017 Михаил Нечаев. All rights reserved.
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var high: Int16
    @NSManaged public var low: Int16
    @NSManaged public var text: String?
}

