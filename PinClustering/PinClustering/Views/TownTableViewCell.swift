//
//  TownTableViewCell.swift
//  PinClustering
//
//  Created by Norbert Agoston on 06/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit

class TownTableViewCell: UITableViewCell {

    @IBOutlet weak var townName: UILabel!
    @IBOutlet weak var webServiceDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCellFor(town: Town) {
        townName.text = town.name
        webServiceDescription.text = town.webServiceDescription
    }
}
