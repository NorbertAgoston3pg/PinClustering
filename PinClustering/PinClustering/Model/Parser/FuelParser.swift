//
//  FuelParser.swift
//  PinClustering
//
//  Created by Norbert Agoston on 14/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit

class FuelParser: Parser {
    override func parse(_ data: Data?) -> AnyObject? {
        guard let data = data else {
            return nil
        }
        
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
        guard let locations = json as? [[String: AnyObject]] else {
            return nil
        }
        
        return locations as AnyObject?
    }
}
