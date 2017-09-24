//
//  DataSource.swift
//  WeatherVoronezh
//
//  Created by Михаил Нечаев on 20.09.17.
//  Copyright © 2017 Михаил Нечаев. All rights reserved.
//

import Foundation
import CoreData

class DataSource: NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherVoronezh")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let formatter: DateFormatter = {
        let myFormatter = DateFormatter()
        myFormatter.locale = Locale(identifier: "en_US_POSIX")
        myFormatter.dateFormat = "dd MMM yyyy"
        return myFormatter
    }()
    
    func save (context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
   
    func getData() -> [Forecast] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Forecast")
        var returnObjects = [Forecast]()
        do {
            let forecasts = try managedContext.fetch(fetchRequest)
            for forecastObject in forecasts {
                let forecast = forecastObject as! Forecast
                returnObjects.append(forecast)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return returnObjects
    }
    
    func write(weather: [ForecastStruct]) {
        self.removeData()
        for forecastStruct in weather {
            let managedContext = persistentContainer.viewContext
            let _ = Forecast.init(with: forecastStruct, and: managedContext)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    private func removeData() {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: managedContext)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
