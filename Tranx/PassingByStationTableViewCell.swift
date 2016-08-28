//
//  PassingByStationTableViewCell.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/10/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import UIKit

class PassingByStationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trainNumberLabel: UILabel!
    @IBOutlet weak var trainNameLabel: UILabel!
    @IBOutlet weak var schArrivalLabel: UILabel!
    @IBOutlet weak var expectArrivalLabel: UILabel!
    @IBOutlet weak var schDepartureLabel: UILabel!
    @IBOutlet weak var expectDepartureLabel: UILabel!
    @IBOutlet var delayOrNoDelayLabel: [UILabel]!
}
