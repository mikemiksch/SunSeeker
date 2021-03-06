//
//  ListViewController.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var cityTable: UITableView!

    var cities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Nearest Sun to You"
        let weatherCell = UINib(nibName: "WeatherTableViewCell", bundle: nil)
        self.cityTable.register(weatherCell, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        self.cityTable.rowHeight = 80
        self.cityTable.delegate = self
        self.cityTable.dataSource = self
        self.cityTable.layer.cornerRadius = 10.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        if segue.identifier == ForecastViewController.identifier {
            if let selectedIndex = self.cityTable.indexPathForSelectedRow?.row {
                let selectedCity = self.cities[selectedIndex]
                guard let destinationController = segue.destination as? ForecastViewController else { return }
                destinationController.city = selectedCity
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        
        let city = self.cities[indexPath.row]
        cell.cellImage.image = UIImage(named: "\(city.icon).png")
        cell.cityLabel.text = city.name
        cell.weatherLabel.text = city.description
        cell.distanceLabel.text = "\(city.distance) miles away"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: ForecastViewController.identifier, sender: nil)
    }

}


// MARK: UIResponder extension

