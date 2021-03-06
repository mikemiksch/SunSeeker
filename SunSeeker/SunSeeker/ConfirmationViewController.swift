//
//  ConfirmationViewController.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit
import CoreData

class ConfirmationViewController: UIViewController {
    
    @IBOutlet weak var returnFlightArrivalInfoLabel: UILabel!
    @IBOutlet weak var returnFlightDepartureInfoLabel: UILabel!
    @IBOutlet weak var departingFlightDepartureInfoLabel: UILabel!
    @IBOutlet weak var departingFlightArrivalInfoLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        let newBooking = Booking(departure: departureFlight, returning: returnFlight)
        BookingsViewController.fakeFunctionality.append(newBooking)
        self.navigationController?.popToRootViewController(animated: true)
        presentAlert()
    }

    var departureFlight : Flight!
    var returnFlight : Flight!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Confirm Booking"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        self.confirmButton.layer.cornerRadius = 10.0
        self.departingFlightDepartureInfoLabel.text = "\(departureFlight.carrier) Flight \(departureFlight.flightNumber)\nDeparting \(dateFormatter.string(from: departureFlight.departureTime))"
        self.departingFlightArrivalInfoLabel.text = "Arriving \(dateFormatter.string(from:departureFlight.arrivalTime))"
        
        self.returnFlightDepartureInfoLabel.text = "\(returnFlight.carrier) Flight \(departureFlight.flightNumber)\nDeparting \(dateFormatter.string(from: returnFlight.departureTime))"
        self.returnFlightArrivalInfoLabel.text = "Arriving \(dateFormatter.string(from:returnFlight.arrivalTime))"
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: nil, message: "Booking Confirmed!", preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okay)
        self.present(alert, animated: true, completion: nil)
    }
    
//   Ran out of time trying to get CoreData or iCloud implemented to persist itinerary data between sessions of the app  
//
//    func save() {
//        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = delegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Bookings", in: managedContext)!
//        let newBooking = NSManagedObject(entity: entity, insertInto: managedContext)
//        
//        newBooking.setValue(departureFlight, forKeyPath: "departureFlight")
//        newBooking.setValue(returnFlight, forKeyPath: "returnFlight")
//        
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Could not save. \(error.description)")
//        }
//    }

}
