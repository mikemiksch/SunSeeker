//
//  ViewController.swift
//  Maps
//
//  Created by Brandon T on 2017-02-20.
//  Copyright © 2017 XIO. All rights reserved.
//

import UIKit
import MapKit


class ImageAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var colour: UIColor?
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.image = nil
        self.colour = UIColor.white
    }
}

class ImageAnnotationView: MKAnnotationView {
    private var imageView: UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.addSubview(self.imageView)
        
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
    }
    
    override var image: UIImage? {
        get {
            return self.imageView.image
        }
        
        set {
            self.imageView.image = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.initControls()
        self.doLayout()
        self.loadAnnotations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initControls() {
        self.mapView = MKMapView()
        
        self.mapView.isRotateEnabled = true
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        let center = CLLocationCoordinate2DMake(43.761539, -79.411079)
        let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.005, 0.005))
        self.mapView.setRegion(region, animated: true)
    }
    
    func doLayout() {
        self.view.addSubview(self.mapView)
        self.mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {  //Handle user location annotation..
            return nil  //Default is to let the system handle it.
        }
        
        if !annotation.isKind(of: ImageAnnotation.self) {  //Handle non-ImageAnnotations..
            var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DefaultPinView")
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DefaultPinView")
            }
            return pinAnnotationView
        }
        
        //Handle ImageAnnotations..
        var view: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? ImageAnnotationView
        if view == nil {
            view = ImageAnnotationView(annotation: annotation, reuseIdentifier: "imageAnnotation")
        }
        
        let annotation = annotation as! ImageAnnotation
        view?.image = annotation.image
        view?.annotation = annotation
        
        return view
    }
    
    
    func loadAnnotations() {
        let request = NSMutableURLRequest(url: URL(string: "https://i.imgur.com/zIoAyCx.png")!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error == nil {
                
                let annotation = ImageAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(43.761539, -79.411079)
                annotation.image = UIImage(data: data!, scale: UIScreen.main.scale)
                annotation.title = "Toronto"
                annotation.subtitle = "Yonge & Bloor"
                
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        
        dataTask.resume()
    }
}
