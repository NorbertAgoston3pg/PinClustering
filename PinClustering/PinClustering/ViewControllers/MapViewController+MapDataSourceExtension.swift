//
//  MapViewController+MapDataSourceExtension.swift
//  PinClustering
//
//  Created by Norbert Agoston on 13/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import Foundation

extension MapViewController {
    func updatePointsOfInterestWith(locations: NSArray) {
        for locationInfo in locations {
            let fuelLocation = FuelLocation(locationInfo: locationInfo as? [String : AnyObject])
            self.pointsOfInterest.append(fuelLocation)
        }
    }
}