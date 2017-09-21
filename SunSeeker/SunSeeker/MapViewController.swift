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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherMap: MKMapView!
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
        self.navigationItem.title = "Seek the Sun!"
        self.activityIndicator.startAnimating()
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
        
        
        API.shared.fetchData(callback: { (cities) in
            OperationQueue.main.addOperation {
                self.cities = cities ?? []
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == ListViewController.identifier {
            guard let destinationController = segue.destination as? ListViewController else { return }
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

}

// MARK: CustomPointAnnotation definition
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
