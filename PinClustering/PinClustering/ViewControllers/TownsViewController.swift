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

    @IBOutlet weak var townsTableView: UITableView!
    
    private var towns = [Town]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTownsTableView()
        loadTowns()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    //townCellIdentifier
    
    // MARK: Private Methods
    
    func setupTownsTableView() {
        townsTableView.registerNib(UINib(nibName: "TownTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: TownsViewController.cellId)
    }
    
    func loadTowns() {
        
        let webServiceURL = NSURL(string: "https://data.cityofchicago.org/resource/alternative-fuel-locations.json?")
        let town = Town(name: "Chicago",
                        webServiceDescription: "Alternative Fuel Locations",
                        webServiceURL: webServiceURL!)
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
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TownsViewController.cellId, forIndexPath: indexPath) as! TownTableViewCell
        
        if indexPath.row < towns.count {
            cell.setupCellFor(towns[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let townMap = MapViewController(nibName: "MapViewController", bundle: nil)
        
        if indexPath.row < towns.count {
            townMap.town = towns[indexPath.row]
        }
        
        navigationController?.pushViewController(townMap, animated: true)
    }
}
