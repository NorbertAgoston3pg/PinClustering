//
//  AlertManager.swift
//  PinClustering
//
//  Created by Norbert Agoston on 13/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit

class AlertManager {
    static let sharedInstance = AlertManager()
    
    func displayAlert(_ title: String, message: String, presentingViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        presentingViewController.present(alert, animated: true, completion: nil)
    }
}
