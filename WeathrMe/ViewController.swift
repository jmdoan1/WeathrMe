//
//  ViewController.swift
//  WeathrMe
//
//  Created by Justin Doan on 9/5/17.
//  Copyright © 2017 Justin Doan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)))
        tap.delegate = self
        //tap.numberOfTapsRequired = 2 //"Double tap" specified in requirements
        mapView.addGestureRecognizer(tap)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            centerMap()
            print("AUTHORIZED")
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //this stub is required
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //this stub is also required
        print(error)
    }
    
    func centerMap() {
        locationManager.requestLocation()
        currentLocation = locationManager.location!.coordinate
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(currentLocation,
                                                                  1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func handleTap(_ sender: UILongPressGestureRecognizer) {
        print("TAPPED")
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        currentLocation = coordinate
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(currentLocation,
                                                                  1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

