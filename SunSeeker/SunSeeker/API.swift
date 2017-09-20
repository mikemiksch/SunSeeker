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

struct API {
    static var shared = API()
    let apiKey = AppDelegate.valueForAPIKey(keyName: "APIKey")
    var location = CLLocation(latitude: 47.6062, longitude: -122.3321)
    
    mutating func fetchData(callback: @escaping CitiesCallback) {
        
        guard let callURL = URL(string: "https://api.openweathermap.org/data/2.5/box/city?bbox=-138.855508,36.385968,-105.720743,59.017976,100&cnt=50&APPID=\(apiKey)") else { return }
        
        //        guard let callURL = URL(string: "https://api.openweathermap.org/data/2.5/find?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&cnt=50&APPID=\(apiKey)") else { return }
        
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
    
}
