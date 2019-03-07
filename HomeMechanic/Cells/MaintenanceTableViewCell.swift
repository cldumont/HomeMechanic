//
//  MaintenanceTableViewCell.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/6/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import UIKit

class MaintenanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var odometerLabel: UILabel!
    @IBOutlet weak var actualDateLabel: UILabel!
    @IBOutlet weak var actualOdometerLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
