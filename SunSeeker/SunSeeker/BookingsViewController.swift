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
    
    // Ran out of time trying to implement either local storage or iCloud functionality to persist the bookings beyond sessions of the app, so I faked it to simulate the functionality.
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
            let alertController = UIAlertController(title: nil, message: "Cancel these reservations?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel Bookings", style: .destructive, handler: { (action) in
                BookingsViewController.fakeFunctionality.remove(at: indexPath.row)
                self.bookingsTable.reloadData()
            })
            alertController.addAction(cancelAction)
            
            let keepAction = UIAlertAction(title: "Keep Bookings", style: .default, handler: nil)
            alertController.addAction(keepAction)
            present(alertController, animated: true, completion: nil)
        }
    }

}
