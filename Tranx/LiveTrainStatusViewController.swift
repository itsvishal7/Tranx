//
//  LiveTrainStatusViewController.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/7/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import UIKit

class LiveTrainStatusViewController: UIViewController {
    
    @IBOutlet weak var trainNumberTextField: CustomTextField! {
        didSet {
            trainNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var recentTrainStatusCheckedTableView: UITableView! {
        didSet {
            self.recentTrainStatusCheckedTableView.dataSource = self // should be hidden until searched
            self.recentTrainStatusCheckedTableView.delegate = self
        }
    }
    
    @IBOutlet weak var trainStartDateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var startDate: String!
    var recentSearches = [JourneyInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Live Train Status"
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.userInteractionEnabled = true
    }
    
    // Mark: View Related Methods
    @IBAction func showActionSheetForTrainStartDate(sender: UITapGestureRecognizer) {
        
        guard let trainNumber = Int((self.trainNumberTextField?.text)!) where trainNumber <= 99999 && trainNumber >= 10000   else {
            print("Make Textfield Shakeable")
            self.trainNumberTextField.shake()
            return
        }
        let datesActionSheet = UIAlertController(title: "Pick One", message: nil, preferredStyle: .ActionSheet)
        
        datesActionSheet.addAction(UIAlertAction(title: "Today", style: .Default) { [unowned self] actionsheet in
          self.trainStartDateLabel.text = actionsheet.title!
            })
        datesActionSheet.addAction(UIAlertAction(title: "Yesterday", style: .Default) { [unowned self] actionsheet in
            self.trainStartDateLabel.text = actionsheet.title!
            })
        datesActionSheet.addAction(UIAlertAction(title: "2 Days Back", style: .Default) { [unowned self] actionsheet in
            self.trainStartDateLabel.text = actionsheet.title!
            })
        datesActionSheet.addAction(UIAlertAction(title: "3 Days Back", style: .Default) { [unowned self] actionsheet in
            self.trainStartDateLabel.text = actionsheet.title!
            })
        datesActionSheet.addAction(UIAlertAction(title: "4 Days Back", style: .Default) { [unowned self] actionsheet in
            self.trainStartDateLabel.text = actionsheet.title!
            })
        datesActionSheet.addAction(UIAlertAction(title: "5 Days Back", style: .Default) { [unowned self] actionsheet in
            self.trainStartDateLabel.text = actionsheet.title!
            })
        presentViewController(datesActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func checkLiveTrainStatus() {
        print("Submit Pressed. Fetch for status")
        
        guard let trainNumber = Int((self.trainNumberTextField?.text)!) where trainNumber <= 99999 && trainNumber >= 10000   else {
            print("Make Textfield Shakeable")
            self.trainNumberTextField.shake()
            return
        }
        
        var today: String!
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        
        switch self.trainStartDateLabel.text! {
        case "Today": today = formatter.stringFromDate(NSDate())
        case "Yesterday": today = formatter.stringFromDate(NSDate().dateByAddingTimeInterval(-86400))
        case "2 Days Back": today = formatter.stringFromDate(NSDate().dateByAddingTimeInterval(-86400*2))
        case "3 Days Back": today = formatter.stringFromDate(NSDate().dateByAddingTimeInterval(-86400*3))
        case "4 Days Back": today = formatter.stringFromDate(NSDate().dateByAddingTimeInterval(-86400*4))
        case "5 Days Back": today = formatter.stringFromDate(NSDate().dateByAddingTimeInterval(-86400*5))
        default: break //Do nothing
        }
        
        self.fetchLiveStatus(Int(self.trainNumberTextField.text!)!, doj: Int(today)!)
    }
    
    func fetchLiveStatus(trainNumber: Int, doj: Int) {
        RailwayService.fetchLiveTrainStatus(trainNumber,doj: doj) { [weak self] (liveStatus, code) in
            
            if let weakself = self {
                weakself.activityIndicator.stopAnimating()
                weakself.view.userInteractionEnabled = true
                if code == 200 {
                    weakself.recentSearches.append(JourneyInfo(trainNumber: trainNumber, journeyDate: doj))
                    weakself.recentTrainStatusCheckedTableView.reloadData()
                    
                    if let destinationVC = weakself.storyboard?.instantiateViewControllerWithIdentifier("ShowingLiveStatus") as? ShowingLiveTrainStatusViewController {
                        destinationVC.liveTrainStatusKeys = liveStatus
                        destinationVC.startDate = doj
                        weakself.showViewController(destinationVC, sender: nil)
                    }
                }else if code == 204 {
                    let alert = UIAlertController(title: "Network Error", message: "Unable to Fetch Status", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "⟳ Retry", style: .Default) { alerts in
                        weakself.fetchLiveStatus(trainNumber, doj: doj)
                        })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    
                    weakself.presentViewController(alert, animated: true, completion: nil)
                    
                }else if code == 510 {
                    let alert = UIAlertController(title: "Invalid Date", message: "Train does not run on this date", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    
                    weakself.presentViewController(alert, animated: true, completion: nil)
                }
                else {
                    print("Unknown error")
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

struct JourneyInfo {
    let trainNumber: Int
    let journeyDate: Int
}

extension LiveTrainStatusViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("call api method here")
    }
}

extension LiveTrainStatusViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Data Source Methods
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Searches"
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RECENT_SEARCHED_TRAINS")!
        
        cell.detailTextLabel?.text = "🗑"
        cell.textLabel?.text = "Train Number: "+String(recentSearches[indexPath.row].trainNumber)
        
        return cell
    }
    
    // Delegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.fetchLiveStatus(self.recentSearches[indexPath.row].trainNumber, doj: self.recentSearches[indexPath.row].journeyDate)
        self.trainNumberTextField.text = nil
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            self.recentSearches.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
}

