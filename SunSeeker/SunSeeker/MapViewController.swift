//
//  MapViewController.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var bookingsButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherMap: MKMapView!
    
    @IBOutlet weak var listButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookingButtonLeadingConstraint: NSLayoutConstraint!

    @IBAction func listButtonPressed(_ sender: Any) {
    }
    
    static var userLocation = CLLocation()

    
    let locationManager = CLLocationManager()
    var forecasts = [Forecast]()
    var cities = [City]() {
        didSet {
            addAnnotations()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        applyFormatting()
        mapSetup()
        API.shared.fetchData(callback: { (cities) in
            OperationQueue.main.addOperation {
                self.cities = cities ?? []
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.animations()
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == ListViewController.identifier {
            guard let destinationController = segue.destination as? ListViewController else { return }
            let backButton = UIBarButtonItem()
            backButton.title = "Back"
            navigationItem.backBarButtonItem = backButton
            destinationController.cities = cities.sorted(by: { (first, second) -> Bool in
                if first.rank < second.rank {
                    return true
                }
                
                if first.rank == second.rank {
                    return first.distance < second.distance
                }
                return false
            })
        }
    }
    
    func addAnnotations() {
        for city in cities {
            let location = city.twoDLocation
            let annotation = CustomPointAnnotation()
            annotation.coordinate = location
            annotation.title = city.name
            annotation.subtitle = city.description
            annotation.imageName = city.icon
            weatherMap.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            print("Not a valid CustomPointAnnotation registration")
            return nil
        }
        
        let identifier = "weatherIcon"
        
        var annotationView = weatherMap.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        let customAnnotation = annotation as! CustomPointAnnotation
        annotationView!.image = UIImage(named: "\(customAnnotation.imageName!).png")
        
        return annotationView
    }
    
    func applyFormatting() {
        self.navigationItem.title = "SunSeeker"
        weatherMap.layer.cornerRadius = 25.0
        listButton.layer.cornerRadius = 10.0
        bookingsButton.layer.cornerRadius = 10.0
        listButton.titleLabel?.adjustsFontSizeToFitWidth = true
        listButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        bookingsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        bookingsButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
    }
    
    func animations() {
        UIView.animate(withDuration: 1.0, animations: {
            self.bookingButtonLeadingConstraint.constant = 0
            self.listButtonTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func mapSetup() {
        let center = CLLocationCoordinate2DMake(47.6062, -122.3321)
        let span = MKCoordinateSpanMake(3, 3)
        let region = MKCoordinateRegionMake(center, span)
        weatherMap.setRegion(region, animated: true)
        weatherMap.delegate = self
        weatherMap.showsUserLocation = true
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
            let currentCoordinates = locationManager.location?.coordinate
            MapViewController.userLocation = CLLocation(latitude: (currentCoordinates?.latitude)!, longitude: (currentCoordinates?.longitude)!)
        } else {
            MapViewController.userLocation = CLLocation(latitude: 47.6062, longitude: -122.3321)
        }
    }

}
