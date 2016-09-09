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
            //update map
        }
    }
    
    func updatePointsOfInterestWith(locations: NSArray) {
        for locationInfo in locations {
            let fuelLocation = FuelLocation(locationInfo: locationInfo as? [String : AnyObject])
            self.pointsOfInterest.append(fuelLocation)
        }
    }
    
    func setupMap() {
        
    }
    
    func displayLocationsOnMap() {
        
    }
}
