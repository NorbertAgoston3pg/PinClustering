//
//  TownsViewController.swift
//  PinClustering
//
//  Created by Norbert Agoston on 02/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit

class TownsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate static let cellId = "townCellIdentifier"
    fileprivate static let webServiceURI = "alternative-fuel-locations.json?"
    fileprivate static let webServiceDescription = "Alternative Fuel Locations"
    fileprivate static let townName = "Chicago"
    fileprivate static let rowHeight: CGFloat = 70.0

    @IBOutlet weak var townsTableView: UITableView!
    
    fileprivate var towns = [Town]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Load Xib With name = \(String(describing:TownTableViewCell()))")
        townsTableView.register(UINib(nibName: String(describing:TownTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: TownsViewController.cellId)
        loadTowns()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Private Methods
    
    func loadTowns() {
        let town = Town(name: TownsViewController.townName,
                        webServiceDescription: TownsViewController.webServiceDescription,
                        webServiceURI: TownsViewController.webServiceURI)
        towns.append(town)
    }
    
    // MARK: TableViewDelegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return towns.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TownsViewController.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TownsViewController.cellId, for: indexPath) as! TownTableViewCell
        
        guard (indexPath as IndexPath).row < towns.count else {
            return cell
        }
        
        cell.setupCellFor(towns[(indexPath as IndexPath).row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard (indexPath as IndexPath).row < towns.count else {
            return
        }
        
        let townMap = MapViewController(nibName: "MapViewController", bundle: nil)
        townMap.town = towns[(indexPath as IndexPath).row]
        navigationController?.pushViewController(townMap, animated: true)
    }
}
