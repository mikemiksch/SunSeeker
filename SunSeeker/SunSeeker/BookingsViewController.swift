//
//  BookingsViewController.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit

class BookingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var bookingsTable: UITableView!
    
    static var fakeFunctionality = [Booking]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Current Itineraries"
        let bookingCell = UINib(nibName: "BookingTableViewCell", bundle: nil)
        self.bookingsTable.register(bookingCell, forCellReuseIdentifier: BookingTableViewCell.identifier)
        self.bookingsTable.tableFooterView = UIView()
        self.bookingsTable.rowHeight = 230
        self.bookingsTable.delegate = self
        self.bookingsTable.dataSource = self
        self.bookingsTable.layer.cornerRadius = 10.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookingsViewController.fakeFunctionality.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let cell = bookingsTable.dequeueReusableCell(withIdentifier: BookingTableViewCell.identifier, for: indexPath) as! BookingTableViewCell
        
        let booking = BookingsViewController.fakeFunctionality[indexPath.row]
        
        cell.departingFlightDepartureInfoLabel.text = "\(booking.departureFlight.carrier) Flight \(booking.departureFlight.flightNumber)\nDeparting \(dateFormatter.string(from: booking.departureFlight.departureTime))"
        cell.departingFlightArrivalInfoLabel.text = "Arriving \(dateFormatter.string(from:booking.departureFlight.arrivalTime))"
        
        cell.returnFlightDepartureInfoLabel.text = "\(booking.returnFlight.carrier) Flight \(booking.departureFlight.flightNumber)\nDeparting \(dateFormatter.string(from: booking.returnFlight.departureTime))"
        cell.returnFlightArrivalInfoLabel.text = "Arriving \(dateFormatter.string(from:booking.returnFlight.arrivalTime))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            BookingsViewController.fakeFunctionality.remove(at: indexPath.row)
            self.bookingsTable.reloadData()
        }
    }

}
