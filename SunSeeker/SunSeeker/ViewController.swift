//
//  ViewController.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/20/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.fetchData(callback: { (cities) in
            OperationQueue.main.addOperation {
                self.cities = cities ?? []
            }
            print(self.cities.count)
            for each in self.cities {
                print(each.name)
                print(each.distance)
            }
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
