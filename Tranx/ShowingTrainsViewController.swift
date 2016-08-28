//
//  ShowingTrainsViewController.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/15/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import UIKit

class ShowingTrainsViewController: UIViewController {
    
    @IBOutlet weak var showingDateLabel: UILabel! {
        didSet {
            self.showingDateLabel.text = self.date ?? nil
        }
    }
    
    @IBOutlet weak var trainListTableView: UITableView!{
        didSet {
            self.trainListTableView.dataSource = self
            self.trainListTableView.delegate = self
        }
    }
    
    var trains: Keys.TrainsListKeys! {
        didSet {
            self.trainListTableView?.reloadData()
        }
    }
    
    var date: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Trains Lists"
    }
    
    @IBAction func changeDateButtonPressed(sender: UIButton) {
        // change date here then call fetch func here then assign return value to trains variable.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ShowingTrainsViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trains.trainNumber.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Trains") as! ShowingTrainListTableViewCell
        cell.trainNumberLabel.text = trains.trainNumber[indexPath.row]
        cell.trainNameLabel.text = trains.trainName[indexPath.row]
        cell.fromStationLabel.text = trains.fromStation[indexPath.row]
        cell.toStationLabel.text = trains.toStation[indexPath.row]
        cell.arrivalTimeAtSourceLabel.text = trains.sourceDepartureTime[indexPath.row]
        cell.arrivalTimeAtDestinationLabel.text = trains.destinationArrivalTime[indexPath.row]
        return cell
    }
    
    // Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("train") as? InfoTrainViewController {
            let trainName = self.trains.trainName[indexPath.row]
            let trainNumber = self.trains.trainNumber[indexPath.row]
            let runs = self.trains.days[indexPath.row]
            destinationVC.train = Keys.TrainKeys(trainNumber: trainNumber, trainName: trainName, runsOn: runs)
            self.showViewController(destinationVC, sender: nil)
        }
    }
}