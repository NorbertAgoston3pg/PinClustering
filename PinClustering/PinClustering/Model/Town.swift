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
    var webServiceURI: String?
    
    init(name: String, webServiceDescription: String, webServiceURI: String) {
        super.init()
        
        self.name = name
        self.webServiceDescription = webServiceDescription
        self.webServiceURI = webServiceURI
    }
}
