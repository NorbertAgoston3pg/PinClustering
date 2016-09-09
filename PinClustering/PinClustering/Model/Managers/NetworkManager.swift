//
//  NetworkManager.swift
//  PinClustering
//
//  Created by Norbert Agoston on 06/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    static let sharedInstance = NetworkManager()
    
    func httpGet(url: NSURL, callback: (NSArray?, String?) -> Void) {
        let configuration =  NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let request = NSMutableURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            do {
                if error != nil {
                    callback(nil,error?.localizedDescription)
                } else {
                    if let responseData = data {
                        let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments)
                        
                        if let locations = json as? [[String: AnyObject]] {
                            callback(locations,nil)
                        }
                    }
                }
            } catch {
                callback(nil,"error serializing JSON: \(error)")
            }
        }
        task.resume()
    }
}
