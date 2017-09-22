//
//  DatePickerViewController.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/21/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var backdrop: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var departureFlight : Flight!
    var city : City!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Return Date"
        self.datePicker.minimumDate = Date()
        self.backdrop.layer.cornerRadius = 10.0
        self.button.layer.cornerRadius = 10.0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        if segue.identifier == ReturnViewController.identifier {
            guard let destinationController = segue.destination as? ReturnViewController else { return }
            destinationController.departureFlight = departureFlight
            destinationController.city = city
            destinationController.selectedDate = datePicker.date
        }
    }
}
