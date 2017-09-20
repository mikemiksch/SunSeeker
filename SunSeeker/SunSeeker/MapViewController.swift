//
//  MapViewController.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var weatherMap: MKMapView!
    
    static var userLocation = CLLocation()
    
    var cities = [City]() {
        didSet {
            addAnnotations()
//            print(cities.count)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.fetchData(callback: { (cities) in
            OperationQueue.main.addOperation {
                self.cities = cities ?? []
            }
        })
        let center = CLLocationCoordinate2DMake(47.6062, -122.3321)
        let span = MKCoordinateSpanMake(50, 50)
        let region = MKCoordinateRegionMake(center, span)
        weatherMap.setRegion(region, animated: true)
        
    }
    
    func addAnnotations() {
        for city in cities {
//            print(city.name)
//            print(city.description)
//            print(city.distance)
            let location = city.twoDLocation
            let annotation = CustomPointAnnotation()
            annotation.coordinate = location
            annotation.title = city.name
            annotation.subtitle = city.description
            annotation.imageName = city.icon
//            print(city.icon)
//            annotation.image = UIImage(contentsOfFile: bundlePath!)!
            weatherMap.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            print("Not a valid MKPointAnnotation registration")
            return nil
        }
        print("hi")
        
        var annotationView = weatherMap.dequeueReusableAnnotationView(withIdentifier: "weatherIcon")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "weatherIcon")
        } else {
            annotationView!.annotation = annotation
        }
        
        let customAnnotation = annotation as! CustomPointAnnotation
        annotationView!.image = UIImage(named: "\(customAnnotation.imageName).png")
        
        return annotationView
    }

}
