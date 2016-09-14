//
//  TownsViewController.swift
//  PinClustering
//
//  Created by Norbert Agoston on 02/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit

class TownsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private static let cellId = "townCellIdentifier"
    private static let webServiceURI = "alternative-fuel-locations.json?"
    private static let webServiceDescription = "Alternative Fuel Locations"
    private static let townName = "Chicago"
    private static let rowHeight: CGFloat = 70.0

    @IBOutlet weak var townsTableView: UITableView!
    
    private var towns = [Town]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        townsTableView.registerNib(UINib(nibName: String(TownTableViewCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: TownsViewController.cellId)
        loadTowns()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    // MARK: Private Methods
    
    func loadTowns() {
        let town = Town(name: TownsViewController.townName,
                        webServiceDescription: TownsViewController.webServiceDescription,
                        webServiceURI: TownsViewController.webServiceURI)
        towns.append(town)
    }
    
    // MARK: TableViewDelegate Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return towns.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TownsViewController.rowHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TownsViewController.cellId, forIndexPath: indexPath) as! TownTableViewCell
        
        guard indexPath.row < towns.count else {
            return cell
        }
        
        cell.setupCellFor(towns[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard indexPath.row < towns.count else {
            return
        }
        
        let townMap = MapViewController(nibName: "MapViewController", bundle: nil)
        townMap.town = towns[indexPath.row]
        navigationController?.pushViewController(townMap, animated: true)
    }
}
