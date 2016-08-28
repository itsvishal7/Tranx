//
//  TrainsPassingByStationsViewController.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/10/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import UIKit

class TrainsPassingByStationsViewController: UIViewController {

    @IBOutlet weak var fromStationLabel: CustomTextField!
    
    @IBOutlet weak var trainPassingByTableView: UITableView! {
        didSet {
            self.trainPassingByTableView.dataSource = self
        }
    }
    
    var trains: Keys.TrainsPassingBy! {
        didSet {
            self.trainPassingByTableView.reloadData()
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Passing By"

        // Do any additional setup after loading the view.
    }

    @IBAction func searchForTrainsPassingBy() {
        guard self.fromStationLabel.text != "" else {
            self.fromStationLabel.shake()
            return
        }
        
        RailwayService.fetchTrainsPassingBy(self.fromStationLabel.text!) {[weak self] (input, code) in
            if let weakself = self {
                weakself.view.userInteractionEnabled = true
                weakself.activityIndicator.stopAnimating()
                if code == 200 {
                    weakself.trains = input
                }else if code == 204 {
                    let alert = UIAlertController(title: "❗️", message: "Network Error", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    weakself.presentViewController(alert, animated: true, completion: nil)
                } else if code == 0 {
                    let alert = UIAlertController(title: nil, message: "There are no trains passing by \(weakself.fromStationLabel.text!) in 2 hrs", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    weakself.presentViewController(alert, animated: true, completion: nil)
                }else {
                    // exhausted api key
                }
            }
        }
        self.activityIndicator.hidden = false
        self.view.userInteractionEnabled = false
        self.activityIndicator.startAnimating()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TrainsPassingByStationsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Train departing/arriving in next 2 hrs"
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trains?.trainNumber.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TRAIN_PASSING_BY") as! PassingByStationTableViewCell
        var delay: String
        if trains.delayOrNoDelay[indexPath.row] == "RT" {
            delay = "RT"
        }
        else {
            delay = "Delayed by \(trains.delayOrNoDelay[indexPath.row]) mins"
        }
        cell.delayOrNoDelayLabel[0].text = delay
        cell.delayOrNoDelayLabel[1].text = delay
        cell.trainNumberLabel.text = trains.trainNumber[indexPath.row]
        cell.trainNameLabel.text = trains.trainName[indexPath.row]
        cell.schArrivalLabel.text! = "sch: "+trains.scheduledArrivalAt[indexPath.row]
        cell.expectArrivalLabel.text! = "➔ expect : "+trains.expectedArrivalAt[indexPath.row]
        cell.schDepartureLabel.text! = "sch: "+trains.scheduledDepartureAt[indexPath.row]
        cell.expectDepartureLabel.text! = "➔ expect : "+trains.expectedDepartureAt[indexPath.row]

        return cell
    }
    
    
    // maybe i want to show train details so, delegate methods will be implemented.
}
