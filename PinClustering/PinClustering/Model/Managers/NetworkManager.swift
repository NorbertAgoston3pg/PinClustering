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
    private let baseURL = "https://data.cityofchicago.org/resource/"
    private let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    func httpRequest(URI: String, callback: (NSData?, NSError?) -> Void) {
        guard let requestURL = buildURLForResource(URI) else {
            return
        }
        
        let request = NSMutableURLRequest(URL: requestURL)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                if error != nil {
                    callback(nil,error)
                } else {
                    callback(data,nil)
                }
            }
        }
        task.resume()
    }
    
    func requestData(URI: String?, callback: (NSData?, NSError?) -> Void) {
        guard let URI = URI else {
            return
        }
        httpRequest(URI, callback: callback)
    }
    
    func parseData(URI: String?, parser: Parser, callback: (NSError?) -> Void) {
        guard let URI = URI else {
            return
        }

        httpRequest(URI) { (data, error) in
            parser.parse(data)
            callback(error)
        }
    }
    
    func buildURLForResource(URI: String?) -> NSURL? {
        if let URI = URI {
            return NSURL(string: baseURL + URI)
        }
        return nil
    }
}



