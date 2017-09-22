//
//  BookingTableViewCell.swift
//  SunSeeker
//
//  Created by Mike Miksch on 9/21/17.
//  Copyright © 2017 MikschSoft. All rights reserved.
//

import UIKit

class BookingTableViewCell: UITableViewCell {

    @IBOutlet weak var departingFlightDepartureInfoLabel: UILabel!
    @IBOutlet weak var departingFlightArrivalInfoLabel: UILabel!
    @IBOutlet weak var returnFlightDepartureInfoLabel: UILabel!
    @IBOutlet weak var returnFlightArrivalInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
