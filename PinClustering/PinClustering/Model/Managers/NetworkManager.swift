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
    fileprivate let baseURL = "https://data.cityofchicago.org/resource/"
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func httpRequest(_ URI: String, callback: @escaping (Data?, Error?) -> Void) {
        guard let requestURL = buildURLForResource(URI) else {
            return
        }
        
        let request = URLRequest(url: requestURL)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                if error != nil {
                    callback(nil,error)
                } else {
                    callback(data,nil)
                }
            }
        })

        task.resume()
    }
    
    func requestData(_ URI: String?, callback: @escaping (Data?, Error?) -> Void) {
        guard let URI = URI else {
            return
        }
        httpRequest(URI, callback: callback)
    }
    
    func parseData(_ URI: String?, parser: Parser, callback: @escaping (Error?) -> Void) {
        guard let URI = URI else {
            return
        }

        httpRequest(URI) { (data, error) in
            parser.parse(data)
            callback(error)
        }
    }
    
    func buildURLForResource(_ URI: String?) -> URL? {
        if let URI = URI {
            return URL(string: baseURL + URI)
        }
        return nil
    }
}



