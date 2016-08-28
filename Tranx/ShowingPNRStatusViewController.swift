//
//  ShowingPNRStatusViewController.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/9/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import UIKit

class ShowingPNRStatusViewController: UIViewController {
    
    @IBOutlet weak var displayPNRLabel: UILabel! {
        didSet {
            self.displayPNRLabel.text = pnrStatusKey.pnr
        }
    }
    @IBOutlet weak var trainNumberLabel: UILabel! {
        didSet {
            self.trainNameLabel.text = pnrStatusKey.trainNumber
        }
    }
    @IBOutlet weak var trainNameLabel: UILabel! {
        didSet {
            self.trainNameLabel.text = pnrStatusKey.trainName
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            self.dateLabel.text = pnrStatusKey.date
        }
    }
    @IBOutlet weak var fromStationLabel: UILabel! {
        didSet {
            self.fromStationLabel.text = pnrStatusKey.fromStation
        }
    }
    @IBOutlet weak var toStationLabel: UILabel! {
        didSet {
            self.toStationLabel.text = pnrStatusKey.toStation
        }
    }
    @IBOutlet weak var classLabel: UILabel! {
        didSet {
            self.classLabel.text = pnrStatusKey.claas
        }
    }
    
    var pnrStatusKey: Keys.PNRStatusKeys!
    
    @IBOutlet weak var passengerInfoTableView: UITableView! {
        didSet {
            self.passengerInfoTableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "PNR Status"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension ShowingPNRStatusViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pnrStatusKey.bookingStatus.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Passenger_Info_Cell") as! ShowingPNRTableViewCell
        cell.numberLabel.text = String(indexPath.row+1)
        cell.bookingStatusLabel.text = pnrStatusKey.bookingStatus[indexPath.row]
        cell.currentStatusLabel.text = pnrStatusKey.currentStatus[indexPath.row]
        return cell
    }
}
