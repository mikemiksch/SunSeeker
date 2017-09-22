//
//  API.swift
//  WeatherChallenge
//
//  Created by Mike Miksch on 9/19/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

typealias CitiesCallback = ([City]?) -> ()
typealias ForecastCallback = ([Forecast]?) ->()

struct API {
    static var shared = API()
    let apiKey = AppDelegate.valueForAPIKey(keyName: "APIKey")
    mutating func fetchData(callback: @escaping CitiesCallback) {
        
        // Calling API on a bounding box drawn around a 750mile radius
        guard let callURL = URL(string: "https://api.openweathermap.org/data/2.5/box/city?bbox=-132,37.105,-112,57,10&cnt=50&APPID=\(apiKey)") else { return }
        
        URLSession.shared.dataTask(with: callURL) { (data, response, error) in
            
            if let error = error {
                print("Error retrieving data from Openweathermap: \(error.localizedDescription)")
                callback(nil)
                return
            }
            
            guard response != nil else { callback(nil); return }
            guard let data = data else { callback(nil); return }
            
            JSONParser.parseJSON(data: data, callback: { (success, cities) in
                if success {
                    callback(cities)
                }
            })
        }.resume()
    }
    
    func fetchForecast(cityID: Int, callback: @escaping ForecastCallback) {
        
        // Calling API on 5 day forecase for a specific city
        guard let callURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?id=\(cityID)&APPID=\(apiKey)") else { return }
        
        URLSession.shared.dataTask(with: callURL) { (data, response, error) in
            
            if let error = error {
                print("Error retrieving forecase from Openweathermap: \(error.localizedDescription)")
                callback(nil)
                return
            }
            
            guard response != nil else { callback(nil); return }
            guard let data = data else { callback(nil); return }
            
            JSONParser.parseForecast(data: data, callback: { (success, forecasts) in
                if success {
                    callback(forecasts)
                }
            })
        }.resume()
    }
    
}
