//
//  Location.swift
//  PinClustering
//
//  Created by Norbert Agoston on 22/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit
import MapKit

class Location: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    init(location coord:CLLocationCoordinate2D) {
        self.coordinate = coord
        super.init()
    }
    
    override init() {
        super.init()
    }
}
