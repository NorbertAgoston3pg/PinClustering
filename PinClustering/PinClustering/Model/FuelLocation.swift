//
//  FuelLocation.swift
//  PinClustering
//
//  Created by Norbert Agoston on 08/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import MapKit

class FuelLocation: Location {
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
        
        self.title = self.info?["station_name"] as? String
        self.subtitle = self.info?["fuel_type_code"] as? String
        
        if let location = self.info?["location"] as? [String : AnyObject] {
            let latitude = location["latitude"]?.doubleValue ?? 0.0
            let longitude = location["longitude"]?.doubleValue ?? 0.0
            
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            coordinate = CLLocationCoordinate2D()
        }
    }
}
