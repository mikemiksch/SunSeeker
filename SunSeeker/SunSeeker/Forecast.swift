//
//  Forecast.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/21/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class Forecast {
    let date : Date
    let description : String
    let icon : String
    
    init(json: JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        self.date = dateFormatter.date(from: json["dt_txt"].string!) ?? Date()
        self.date = Date(timeIntervalSince1970: json["dt"].double!)
        self.description = json["weather"][0]["description"].string ?? ""
        self.icon = json["weather"][0]["icon"].string ??  ""
    }
}
