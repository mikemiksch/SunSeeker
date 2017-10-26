//
//  UIResponder+Identifier.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/21/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit

extension UIResponder {
    static var identifier : String {
        return String(describing: self)
    }
}
