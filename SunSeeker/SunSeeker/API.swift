//
//  API.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

typealias CitiesCallback = ([City]?) -> ()

struct API {
    static var shared = API()
    let apiKey = AppDelegate.valueForAPIKey(keyName: "APIKey")
    let seattleCoor = CLLocation(latitude: 47.6062, longitude: -122.3321)
    let north1Coor = CLLocation(latitude: 50.903033, longitude: -122.3321)
    let north2Coor = CLLocation(latitude: 50.903033, longitude: -117.026367)
    let north3Coor = CLLocation(latitude: 50.903033, longitude: -111.313477)
    let east1Coor = CLLocation(latitude: 47.6062, longitude: -117.026367)
    let east2Coor = CLLocation(latitude: 47.6062, longitude: -111.313477)
    let south1Coor = CLLocation(latitude: 43.06888, longitude: -122.3321)
    let south2Coor = CLLocation(latitude: 43.06888, longitude: -117.026367)
    let south3Coor = CLLocation(latitude: 43.06888, longitude: -111.313477)
    let farSouth1Coor = CLLocation(latitude: 38.719805, longitude: -122.3321)
    let farSouth2Coor = CLLocation(latitude: 38.719805, longitude: -117.026367)
    let farSouth3Coor = CLLocation(latitude: 38.719805, longitude: -111.313477)
    
    
    mutating func fetchData(callback: @escaping CitiesCallback) {
        let coordinates = [seattleCoor, north1Coor, north2Coor, north3Coor, east1Coor, east2Coor, south1Coor, south2Coor, south3Coor, farSouth1Coor, farSouth2Coor, farSouth3Coor]
        
        for each in coordinates {
            guard let callURL = URL(string: "https://api.openweathermap.org/data/2.5/find?lat=\(each.coordinate.latitude)&lon=\(each.coordinate.longitude)&cnt=50&APPID=\(apiKey)") else { return }
        
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
    
}
