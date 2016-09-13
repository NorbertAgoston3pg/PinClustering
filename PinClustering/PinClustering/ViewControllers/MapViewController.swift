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
    
    var pointsOfInterest = [AnyObject]()
    
    var town: Town? {
        didSet {
            loadLocations()
        }
    }
    
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
                if let error = error {
                    AlertManager.sharedInstance.displayAlert("Error retrieving locations", message: error, presentingViewController: self)
                }
                return
            }
            
            self.updatePointsOfInterestWith(actualLocations)
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.setupMap(self.pointsOfInterest)
            }
        }
    }
}
