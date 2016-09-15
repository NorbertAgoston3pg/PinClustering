//
//  MapViewController+MapDataSourceExtension.swift
//  PinClustering
//
//  Created by Norbert Agoston on 13/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import Foundation

extension MapViewController {
    func updatePointsOfInterestWith(_ locations: [AnyObject]?) {
        guard let locations = locations else {
            return
        }
        
        self.pointsOfInterest = locations.map { locationInfo in
            return FuelLocation(locationInfo: locationInfo as? [String : AnyObject])
        }
    }
}
