//
//  PNRStatusViewController.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/8/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import UIKit

class PNRStatusViewController: UIViewController {

    @IBOutlet weak var showPNRStatusTableView: UITableView! {
        didSet {
            self.showPNRStatusTableView.dataSource = self //should be hidden until searched
            self.showPNRStatusTableView.delegate = self
        }
    }
    @IBOutlet weak var getPNRNumberTextField: CustomTextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var recentSearches = [PNRStatus]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Check PNR Status"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchPNRStatus(sender: AnyObject) {
        guard let _ = Int((self.getPNRNumberTextField?.text)!) else {
            print("Make Textfield Shakeable")
            self.getPNRNumberTextField.shake()
            return
        }
        self.goFetchStatus(self.getPNRNumberTextField!.text!)
    }
    
    func goFetchStatus(pnrNumber: String){
        RailwayService.fetchPNRStatus(pnrNumber) {[weak self] (pnrStatus, code) in
            if let weakself = self {
                weakself.view.userInteractionEnabled = true
                weakself.activityIndicator.stopAnimating()
                if code == 200 {
                    let today = pnrStatus!.date.characters.split("-")
                    weakself.recentSearches.append(PNRStatus(pnrNumber: pnrStatus!.pnr, trainName: pnrStatus!.trainName, journeyLabel: (pnrStatus!.fromStation+" to "+pnrStatus!.toStation), claas: pnrStatus!.claas, date: String(today[0]), month: String(today[1])))
                    weakself.showPNRStatusTableView.reloadData()
                    
                    if let destinationVC = weakself.storyboard?.instantiateViewControllerWithIdentifier("Showing_PNR_Status") as? ShowingPNRStatusViewController {
                        destinationVC.pnrStatusKey = pnrStatus!
                        weakself.showViewController(destinationVC, sender: nil)
                    }
                }else if code == 410 {
                    let alert = UIAlertController(title: "Invalid PNR Number", message: "PNR not yet generated", preferredStyle: .ActionSheet)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    weakself.presentViewController(alert, animated: true, completion: nil)
                }else if code == 404 {
                    let alert = UIAlertController(title: "Service Down", message: "Retry Again Later", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .Default) { alerts in
                        weakself.goFetchStatus(pnrNumber)
                        })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    weakself.presentViewController(alert, animated: true, completion: nil)
                }else if code == 204 {
                    let alert = UIAlertController(title: "❗️", message: "Network Error", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    weakself.presentViewController(alert, animated: true, completion: nil)
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
struct PNRStatus {
    let pnrNumber: String
    let trainName: String
    let journeyLabel: String
    let claas: String
    let date: String
    let month: String
}

extension PNRStatusViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Data Source Methods
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Searches"
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentSearches.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SHOW_PNR_STATUS") as! PNRStatusTableViewCell
        cell.classLabel.text = self.recentSearches[indexPath.row].claas
        cell.PNRLabel.text = self.recentSearches[indexPath.row].pnrNumber
        cell.TrainNameLabel.text = self.recentSearches[indexPath.row].trainName
        cell.journeyLabel.text = self.recentSearches[indexPath.row].journeyLabel
        cell.dateOfJourneyLabel.text = self.recentSearches[indexPath.row].date
        cell.monthOfJourneyLabel.text = self.recentSearches[indexPath.row].month
        return cell
    }
    
    //Delegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.goFetchStatus(recentSearches[indexPath.row].pnrNumber)
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {[weak self] (action, indexPath) in
            if let weakself = self {
                weakself.recentSearches.removeAtIndex(indexPath.row)
                weakself.showPNRStatusTableView.reloadData()
            }
        })
        deleteAction.backgroundColor = UIColor.cyanColor()
       
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
