//
//  Global.swift
//  WeathrMe
//
//  Created by Justin Doan on 9/5/17.
//  Copyright © 2017 Justin Doan. All rights reserved.
//

import Foundation
import CoreLocation

var currentLocation = CLLocationCoordinate2D()
let apiKey = "68dc4e0dc797bc9e119a8e764a3190f9"

var canGetLocation: Bool {
    if CLLocationManager.locationServicesEnabled() {
        return CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    } else {
        return false
    }
}

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
