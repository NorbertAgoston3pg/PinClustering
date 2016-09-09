//
//  Town.swift
//  PinClustering
//
//  Created by Norbert Agoston on 06/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit

class Town: NSObject {
    
    var name: String?
    var webServiceDescription: String?
    var webServiceURL: NSURL?
    
    init(name: String, webServiceDescription: String, webServiceURL: NSURL) {
        super.init()
        
        self.name = name
        self.webServiceDescription = webServiceDescription
        self.webServiceURL = webServiceURL
    }
}
