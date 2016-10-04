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
    @IBOutlet weak var gridView: UIView!
    
    var pointsOfInterest = [Location]()
    var temporaryPointsOfInterest = [Location]()
        
    var town: Town? {
        didSet {
            loadLocations()
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Private
    
    func loadLocations() {
        guard let uri = town?.webServiceURI else {
            return
        }
        
        NetworkManager.sharedInstance.requestData(uri) { (data, error) in
            guard let data = data else {
                if let error = error {
                    AlertManager.sharedInstance.displayAlert("Error retrieving locations", message: error.localizedDescription, presentingViewController: self)
                }
                return
            }
            guard let parsedData = FuelParser().parse(data) else {
                AlertManager.sharedInstance.displayAlert("Error", message: "No valid locations", presentingViewController: self)
                return
            }
            self.updatePointsOfInterestWith(parsedData as? Array)
            self.setupMap(self.pointsOfInterest)
        }
    }
}
