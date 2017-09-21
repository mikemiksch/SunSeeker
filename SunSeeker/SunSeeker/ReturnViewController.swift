//
//  ReturnViewController.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit

class ReturnViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var flightTable: UITableView!
    var city : City!
    var departureFlight : Flight!
    var flights = [Flight]()
    let calendar = Calendar.current

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.navigationItem.title = "Return Flights From \(city.name)"
        let flightNib = UINib(nibName: "FlightTableViewCell", bundle: nil)
        self.flightTable.register(flightNib, forCellReuseIdentifier: FlightTableViewCell.identifier)
        self.flightTable.rowHeight = 100
        self.flightTable.delegate = self
        self.flightTable.dataSource = self
        
        makeDummyFlights()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        if segue.identifier == ConfirmationViewController.identifier {
            if let selectedIndex = self.flightTable.indexPathForSelectedRow?.row {
                let selectedFlight = self.flights[selectedIndex]
                
                guard let destinationController = segue.destination as? ConfirmationViewController else { return }
                destinationController.departureFlight = departureFlight
                destinationController.returnFlight = selectedFlight
            }
        }
    }
    
    func makeDummyFlights() {
        let currentDate = departureFlight.arrivalTime
        var departureTime = calendar.date(byAdding: .day, value: 1, to: currentDate)
        var arrivalTime = calendar.date(byAdding: .hour, value: 2, to: departureTime!)
        let carriers = ["Delta", "Southwest", "UnitedAir", "JetBlue", "Virgin"]
        
        for _ in 1...10 {
            let newFlight = Flight()
            let randomNum = Int(arc4random_uniform(5))
            newFlight.carrier = carriers[randomNum]
            newFlight.departureAirport = "\(city.name) Airport"
            newFlight.arrivalAirport = "SeaTac Airport"
            newFlight.gate = Int(arc4random_uniform(50)) + 1
            newFlight.flightNumber = Int(arc4random_uniform(1000)) + 1
            newFlight.departureTime = departureTime!
            newFlight.arrivalTime = arrivalTime!
            
            flights.append(newFlight)
            
            departureTime = calendar.date(byAdding: .day, value: 1, to: departureTime!)
            arrivalTime = calendar.date(byAdding: .hour, value: 2, to: departureTime!)
            
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = flightTable.dequeueReusableCell(withIdentifier: FlightTableViewCell.identifier, for: indexPath) as! FlightTableViewCell
        
        let flight = self.flights[indexPath.row]
        cell.flight = flight
        
        // Fill out cell here
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: ConfirmationViewController.identifier, sender: nil)
    }

}
