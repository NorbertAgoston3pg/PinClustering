//
//  MapViewController.swift
//  PinClustering
//
//  Created by Norbert Agoston on 06/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    
    var town: Town? {
        didSet {
            loadLocations()
        }
    }
    
    private var pointsOfInterest = [AnyObject]()
    private let regionRadius: CLLocationDistance = 50000
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
    }
    
    // MARK: Private
    
    func loadLocations() {
        guard let url = town?.webServiceURL else {
            return
        }

        NetworkManager.sharedInstance.httpGet(url) { (locations, error) in
            guard let actualLocations = locations else {
                //handle error
                return
            }
            
            self.updatePointsOfInterestWith(actualLocations)
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.setupMap()
            }
        }
    }
    
    func updatePointsOfInterestWith(locations: NSArray) {
        for locationInfo in locations {
            let fuelLocation = FuelLocation(locationInfo: locationInfo as? [String : AnyObject])
            self.pointsOfInterest.append(fuelLocation)
//            print("Location = \(fuelLocation.coordinate)")
        }
    }
    
    func setupMap() {
        guard let pointOfInterest = pointsOfInterest.first as? FuelLocation else {
            return
        }

        centerMapOnLocation(pointOfInterest.coordinate)
        displayLocationsOnMap()
    }
    
    func displayLocationsOnMap() {
        for pointOfInterest in pointsOfInterest {
            map.addAnnotation(pointOfInterest as! FuelLocation)
        }
    }
    
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
}
