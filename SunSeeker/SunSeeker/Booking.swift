//
//  Booking.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import Foundation

class Booking {
    let departureFlight : Flight
    let returnFlight : Flight
    init(departure: Flight, returning: Flight) {
        self.departureFlight = departure
        self.returnFlight = returning
    }
}
