//
//  ShowingLiveTrainStatusViewController.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/8/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import UIKit

class ShowingLiveTrainStatusViewController: UIViewController {
    var startDate: Int!
    var liveTrainStatusKeys: Keys.LiveTrainKeys!

    @IBOutlet weak var showStatusOfTrainTableView: UITableView! {
        didSet {
            self.showStatusOfTrainTableView.dataSource = self
        }
    }
    @IBOutlet weak var trainNumberLabel: UILabel! {
        didSet {
            self.trainNumberLabel.text = liveTrainStatusKeys.trainNumber
        }
    }
    @IBOutlet weak var currentDateTimeLabel: UILabel! {
        didSet {
            self.currentDateTimeLabel.text = liveTrainStatusKeys.currentTime
        }
    }
    @IBOutlet weak var displayStatusOfTrainLabel: UILabel! {
        didSet {
            self.displayStatusOfTrainLabel.text = liveTrainStatusKeys.status
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Live Train Status"
        
        let reloadBarButton = UIBarButtonItem(title: "🌐", style:.Plain, target: self, action: #selector(reloadStatus))
        self.navigationItem.rightBarButtonItem = reloadBarButton
    }
    
    func reloadStatus(){
        RailwayService.fetchLiveTrainStatus(Int(liveTrainStatusKeys.trainNumber!)!, doj: startDate) { [weak self] (newLiveStatus, code) in
            self?.activityIndicator.stopAnimating()
            if let weakself = self {
                weakself.liveTrainStatusKeys = newLiveStatus!
                weakself.trainNumberLabel.text = newLiveStatus!.trainNumber
                weakself.currentDateTimeLabel.text = newLiveStatus!.currentTime
                weakself.displayStatusOfTrainLabel.text = newLiveStatus!.status
                weakself.showStatusOfTrainTableView.reloadData()
            }
        }
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShowingLiveTrainStatusViewController: UITableViewDataSource, UITableViewDelegate{
    
    //Data Source Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (liveTrainStatusKeys.remainingStations?.count ?? 0)
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Station Names and their ETAs"
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SHOWING_STATUS_CELL")!
        cell.detailTextLabel?.text = liveTrainStatusKeys.estimatedTime![indexPath.row]
        cell.textLabel?.text = liveTrainStatusKeys.remainingStations![indexPath.row]
        return cell
    }
}