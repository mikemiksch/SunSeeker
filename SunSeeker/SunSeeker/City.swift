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
    let id : Int
    let twoDLocation : CLLocationCoordinate2D
    let description : String
    let icon : String
    var rank : String
    let distance : Int
    
    init(json: JSON) {
        self.name = json["name"].string ?? ""
        self.id = json["id"].int ?? 0
        self.coor = CLLocation(latitude: json["coord"]["Lat"].double ?? 0.0, longitude: json["coord"]["Lon"].double  ?? 0.0)
        self.twoDLocation = CLLocationCoordinate2DMake(coor.coordinate.latitude, coor.coordinate.longitude)
        self.description = json["weather"][0]["description"].string ?? ""
        self.icon = json["weather"][0]["icon"].string ??  ""
        self.rank = icon
        if rank.characters.contains("n") {
            rank = "9" + rank
        }
        let location = CLLocation(latitude: MapViewController.userLocation.coordinate.latitude, longitude: MapViewController.userLocation.coordinate.longitude)
        self.distance = Int(round((((coor.distance(from: location)) * 0.000621371) * 1000) / 1000))
    }
}

