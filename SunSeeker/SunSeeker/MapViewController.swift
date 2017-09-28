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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherMap: MKMapView!
    
    @IBOutlet weak var listButtonTrailingConstraint: NSLayoutConstraint!

    @IBAction func listButtonPressed(_ sender: Any) {
    }
    
    static var userLocation = CLLocation()

    
    let locationManager = CLLocationManager()
    var cities = [City]() {
        didSet {
            addAnnotations()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        mapSetup()
        applyFormatting()
//        API.shared.fetchData(callback: { (cities) in
//            OperationQueue.main.addOperation {
//                self.cities = cities ?? []
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.isHidden = true
//                self.animations()
//            }
//        })
        
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
        listButton.titleLabel?.adjustsFontSizeToFitWidth = true
        listButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping

    }
    
    func animations() {
        UIView.animate(withDuration: 1.0, animations: {
            self.listButtonTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func mapSetup() {
//        let center = CLLocationCoordinate2DMake(47.6062, -122.3321)
//        let span = MKCoordinateSpanMake(3, 3)
//        let region = MKCoordinateRegionMake(center, span)
//        weatherMap.setRegion(region, animated: true)
        weatherMap.delegate = self
        weatherMap.showsUserLocation = true
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        MapViewController.userLocation = locations[0]
        let userCoordinate = CLLocationCoordinate2DMake(MapViewController.userLocation.coordinate.latitude, MapViewController.userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(3, 3)
        let region = MKCoordinateRegionMake(userCoordinate, span)
        weatherMap.setRegion(region, animated: true)
        self.weatherMap.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            let userCoordinate = CLLocationCoordinate2DMake(MapViewController.userLocation.coordinate.latitude, MapViewController.userLocation.coordinate.longitude)
            let span = MKCoordinateSpanMake(3, 3)
            let region = MKCoordinateRegionMake(userCoordinate, span)
            weatherMap.setRegion(region, animated: true)
            self.weatherMap.showsUserLocation = true
            API.shared.fetchData(callback: { (cities) in
                OperationQueue.main.addOperation {
                    self.cities = cities ?? []
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.animations()
                }
            })
        } else if status == CLAuthorizationStatus.denied {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            let alert = UIAlertController(title: nil, message: "Please enable location services to use SunSeeker", preferredStyle: .alert)
            let okay = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
    }

}
