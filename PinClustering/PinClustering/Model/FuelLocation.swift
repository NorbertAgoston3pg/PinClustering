//
//  FuelLocation.swift
//  PinClustering
//
//  Created by Norbert Agoston on 08/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit
import MapKit

class FuelLocation: NSObject, MKAnnotation {
    
    var title: String? {
        return info?["station_name"] as? String
    }
    
    var subtitle: String? {
        return info?["fuel_type_code"] as? String
    }
    
    var coordinate: CLLocationCoordinate2D {
        guard let locationInfo = info?["location"] as? [String : AnyObject] else {
            return CLLocationCoordinate2D()
        }
        
        let latitude = locationInfo["latitude"]?.doubleValue ?? 0.0
        let longitude = locationInfo["longitude"]?.doubleValue ?? 0.0
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var city: String? {
        return info?["city"] as? String
    }
    
    var locationId: Int? {
        return info?["id"] as? Int
    }
    
    var dateLastConfirmed: Date? {
        return Date()
    }
    
    var vehicleClass: String? {
        return info?["ng_vehicle_class"] as? String
    }
    
    var state: String? {
        return info?["state"] as? String
    }
    
    var address: String? {
        return info?["street_address"] as? String
    }
    
    var zipCode: String? {
        return info?["zip"] as? String
    }
    
    fileprivate var info: [String: AnyObject]?
    
    init(locationInfo: [String: AnyObject]?) {
        super.init()
        self.info = locationInfo
    }
}
