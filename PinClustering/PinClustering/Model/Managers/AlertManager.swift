//
//  AlertManager.swift
//  PinClustering
//
//  Created by Norbert Agoston on 13/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit

class AlertManager: NSObject {
    static let sharedInstance = AlertManager()
    
    func displayAlert(title: String, message: String, presentingViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentingViewController.presentViewController(alert, animated: true, completion: nil)
    }
}
