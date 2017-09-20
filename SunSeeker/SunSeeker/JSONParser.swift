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
}
