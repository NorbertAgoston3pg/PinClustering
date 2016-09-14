//
//  FuelParser.swift
//  PinClustering
//
//  Created by Norbert Agoston on 14/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit

class FuelParser: Parser {
    override func parse(data: NSData?) -> AnyObject? {
        guard let data = data else {
            return nil
        }
        
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
        guard let locations = json as? [[String: AnyObject]] else {
            return nil
        }
        
        return locations
    }
}
