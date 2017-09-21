//
//  JSONParser.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias JSONParserCallback = (Bool, [City]?) -> ()
typealias JSONForecastCallback = (Bool, [Forecast]?) -> ()

class JSONParser {
    
    class func parseJSON(data: Data, callback: JSONParserCallback) {
        var cities = [City]()
        let json = JSON(data: data)
        let list = Array(json["list"])
        for city in list {
            let newCity = City(json: city.1)
            cities.append(newCity)
        }
        callback(true, cities)
    }
    
    class func parseForecast(data: Data, callback: JSONForecastCallback) {
        var forecasts = [Forecast]()
        let json = JSON(data: data)
        let list = Array(json["list"])
        for forecast in list {
            let newForecast = Forecast(json: forecast.1)
            forecasts.append(newForecast)
        }
        callback(true, forecasts)
    }
}
