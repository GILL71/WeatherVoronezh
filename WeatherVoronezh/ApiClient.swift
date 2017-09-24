//
//  ApiClient.swift
//  WeatherVoronezh
//
//  Created by Михаил Нечаев on 19.09.17.
//  Copyright © 2017 Михаил Нечаев. All rights reserved.
//

import Foundation
import CoreData

enum Result<T> {
    case success(T)
    case failure(Error)
}

struct WeatherServiceError: Error {
    enum Code: Int {
        case URLError                 = -6000
        case NetworkRequestFailed     = -6001
        case JSONSerializationFailed  = -6002
        case JSONParsingFailed        = -6003
    }
    
    let errorCode: Code
}

class ApiClient: NSObject {
    
    let parser = Parser()
    let coreData = DataSource()
    
    func urlRequestForLocation(withName name: String) -> URL? {
        let requestString = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"\(name)\")  and u='c'"
        guard let encodedString = requestString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        let endpoint = "https://query.yahooapis.com/v1/public/yql?q=\(encodedString)&format=json"
        return URL(string: endpoint)
    }
    
    private func retrieveWeather(locationName: String, completionHandler: @escaping (Result<Any>) -> Void) {
        guard let url = urlRequestForLocation(withName: locationName) else {
            let error = WeatherServiceError(errorCode : .URLError)
            completionHandler(Result.failure(error))
            return
        }
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: url) {(data, response, error) in
            if let error = error {
                completionHandler(Result.failure(error))
                return
            }
            if let data = data {
                completionHandler(Result.success(data))
            }
        }
        task.resume()
    }
    
    func requestData(locationName: String)  {
        retrieveWeather(locationName: locationName) {[weak self](result) in
            DispatchQueue.main.async {
                switch (result) {
                case .success(let data):
                    do {
                        if let data = data as? Data {
                            guard let forecasts = try self?.parseNew(data: data) else { return }
                            self?.coreData.write(weather: forecasts)
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print("error : \(error)")
                }
            }
        }
    }
    
    private func parseNew(data: Data) throws -> [ForecastStruct]{
        let json = try! JSONSerialization.jsonObject(with: data)
        var forecasts = [ForecastStruct]()
        do {
            forecasts = try parser.parse(withJson: json)
        }  catch let error as NSError {
            print(error.code)
        }
        return forecasts
    }
}
