//
//  City.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class City {
    let name : String
    let coor : CLLocation
    let temp : Double
    let description : String
    let icon : String
    let weatherID : Int
    let distance : Double
    let iconURL : URL!
    
    init(json: JSON) {
        name = json["name"].string ?? ""
        coor = CLLocation(latitude: json["coord"]["Lat"].double ?? 0.0, longitude: json["coord"]["Lon"].double  ?? 0.0)
        temp = (9.0 / 5.0) * ((json["main"]["temp"].double ?? 0) - 273.0) + 32.0
        description = json["weather"]["description"].string ?? ""
        icon = json["weather"]["icon"].string ??  ""
        weatherID = json["weather"]["id"].int ?? 0
        iconURL = URL(string: "http://openweathermap.org/img/w/\(icon).png")
        distance = round((((coor.distance(from: API.shared.seattleCoor)) * 0.000621371) * 1000) / 1000)
    }
}
