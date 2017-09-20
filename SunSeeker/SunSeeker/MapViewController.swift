//
//  MapViewController.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var weatherMap: MKMapView!
    var cities = [City]() {
        didSet {
            addAnnotations()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.fetchData(callback: { (cities) in
            OperationQueue.main.addOperation {
                self.cities = cities ?? []
            }
        })
        
    }
    
    func addAnnotations() {
        for city in cities {
            print(city.name)
            print(city.description)
            let location = city.twoDLocation
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = city.name
            annotation.subtitle = city.description
            weatherMap.addAnnotation(annotation)
        }
    }

}
