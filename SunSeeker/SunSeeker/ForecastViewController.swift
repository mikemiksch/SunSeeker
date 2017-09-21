//
//  ForecastViewController.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/21/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var forecastTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var city : City!
    var forecasts = [Forecast]() {
        didSet {
            self.forecastTable.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Forecast for \(city.name)"
        self.activityIndicator.startAnimating()
        let forecastCell = UINib(nibName: "ForecastTableViewCell", bundle: nil)
        self.forecastTable.register(forecastCell, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        self.forecastTable.rowHeight = 80
        self.forecastTable.delegate = self
        self.forecastTable.dataSource = self
        API.shared.fetchForecast(cityID: city.id) { (forecasts) in
            OperationQueue.main.addOperation {
                self.forecasts = forecasts ?? []
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        if segue.identifier == DepartureViewController.identifier {
            if let selectedIndex = self.forecastTable.indexPathForSelectedRow?.row {
                let selectedForecast = self.forecasts[selectedIndex]
                guard let destinationController = segue.destination as? DepartureViewController else { return }
                destinationController.city = self.city
                destinationController.date = selectedForecast.date
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTable.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
        let forecast = self.forecasts[indexPath.row]
        
        cell.cellImage.image = UIImage(named: "\(forecast.icon).png")
        cell.date = forecast.date
        cell.weatherLabel.text = forecast.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: DepartureViewController.identifier, sender: nil)
    }
}
