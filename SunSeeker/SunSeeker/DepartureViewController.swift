//
//  DepartureViewController.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit

class DepartureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var flightsToLabel: UILabel!
    @IBOutlet weak var flightTable: UITableView!
    var date : Date!
    var city : City!
    var flights = [Flight]()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Outbound Flights"
        self.flightsToLabel.text = "Flights to \n\(city.name)"
        self.flightTable.layer.cornerRadius = 10.0
        let flightNib = UINib(nibName: "FlightTableViewCell", bundle: nil)
        self.flightTable.register(flightNib, forCellReuseIdentifier: FlightTableViewCell.identifier)
        self.flightTable.rowHeight = 130
        self.flightTable.delegate = self
        self.flightTable.dataSource = self
        
        makeDummyFlights()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        if segue.identifier == DatePickerViewController.identifier {
            if let selectedIndex = self.flightTable.indexPathForSelectedRow?.row {
                let selectedFlight = self.flights[selectedIndex]
                
                guard let destinationController = segue.destination as? DatePickerViewController else { return }
                destinationController.departureFlight = selectedFlight
                destinationController.city = city
            }
        }
    }
    
    func makeDummyFlights() {
        let currentDate = date
        var departureTime = calendar.date(byAdding: .hour, value: 2, to: currentDate!)
        var arrivalTime = calendar.date(byAdding: .hour, value: 2, to: departureTime!)
        let carriers = ["Delta", "Southwest", "UnitedAir", "JetBlue", "Virgin"]
        
        for _ in 1...10 {
            let newFlight = Flight()
            let randomNum = Int(arc4random_uniform(5))
            newFlight.carrier = carriers[randomNum]
            newFlight.departureAirport = "From SeaTac Airport"
            newFlight.arrivalAirport = "At \(city.name) Airport"
            newFlight.gate = Int(arc4random_uniform(50)) + 1
            newFlight.flightNumber = Int(arc4random_uniform(1000)) + 1
            newFlight.departureTime = departureTime!
            newFlight.arrivalTime = arrivalTime!
            
            flights.append(newFlight)
            
            departureTime = calendar.date(byAdding: .hour, value: 2, to: departureTime!)
            arrivalTime = calendar.date(byAdding: .hour, value: 2, to: departureTime!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
       let cell = flightTable.dequeueReusableCell(withIdentifier: FlightTableViewCell.identifier, for: indexPath) as! FlightTableViewCell
        
        let flight = self.flights[indexPath.row]
        cell.flight = flight
        
        cell.flightNumberLabel.text = "Flight \(flight.flightNumber)"
        cell.departureLabel.text = flight.departureAirport
        cell.carrierLabel.text = flight.carrier
        cell.arrivalLabel.text = flight.arrivalAirport
        cell.departureTimeLabel.text = dateFormatter.string(from: flight.departureTime)
        cell.arrivialTimeLabel.text = dateFormatter.string(from: flight.arrivalTime)
        cell.extraLabel.text = "Select Return Date"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: DatePickerViewController.identifier, sender: nil)
    }

}
