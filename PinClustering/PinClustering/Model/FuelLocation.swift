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
        let locationInfo = info?["location"] as? [String : AnyObject]
        let latitude = locationInfo?["latitude"] as! String
        let longitude = locationInfo?["longitude"] as! String
        
        return CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
    }
    
    var city: String? {
        return info?["city"] as? String
    }
    
    var locationId: Int? {
        return info?["id"] as? Int
    }
    
    var dateLastConfirmed: NSDate? {
//        return info?["date_last_confirmed"] as? String
        return NSDate()
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
    
    private var info: [String: AnyObject]?
    
    init(locationInfo: [String: AnyObject]?) {
        super.init()
        self.info = locationInfo
    }
}
