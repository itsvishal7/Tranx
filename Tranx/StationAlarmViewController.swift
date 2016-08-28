//
//  StationAlarmViewController.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/10/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import UIKit
import CoreLocation

class StationAlarmViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var stationNameOrCodeTextField: CustomTextField!
    
    @IBOutlet weak var alarmingDistanceLabel: UILabel!
    
    @IBOutlet weak var displayForSwitchOffMoniteringLabel: UILabel!
    
    @IBOutlet weak var switchLocationSwitch: UISwitch!
    
    let locationManager = CLLocationManager()
    
    typealias KM = Double
    var setAlarmAt: KM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Station Alarm"
        
        locationManager.delegate = self
    }

    @IBAction func alertDistanceSetterTapped(sender: UITapGestureRecognizer) {
        guard self.stationNameOrCodeTextField.text! != "" else {
            self.stationNameOrCodeTextField.shake()
            return
        }
        let alert = UIAlertController(title: "Select", message: nil, preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Alert me 1 km before reaching", style: .Default) { [unowned self] actionsheet in
            self.alarmingDistanceLabel.text = actionsheet.title!
            self.setAlarmAt = 1
            })
        alert.addAction(UIAlertAction(title: "Alert me 2 km before reaching", style: .Default) { [unowned self] actionsheet in
            self.alarmingDistanceLabel.text = actionsheet.title!
            self.setAlarmAt = 2
            })
        alert.addAction(UIAlertAction(title: "Alert me 3 km before reaching", style: .Default) { [unowned self] actionsheet in
            self.alarmingDistanceLabel.text = actionsheet.title!
            self.setAlarmAt = 3
            })
        presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func setReminderPressed() {
        
        guard self.stationNameOrCodeTextField.text! != "" else {
            self.stationNameOrCodeTextField.shake()
            return
        }
        RailwayService.fetchLocationCoordinates("abp") {[weak self] (key, code) in
            if let weakself = self {
                weakself.switchLocationSwitch.setOn(true, animated: true)
                weakself.setAlarm(key!.latitude, longitude: key!.longitude)
                let alert = UIAlertController(title: "Alarm Set", message: "Now! just Wait and we will notify you", preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                weakself.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setAlarm(latitude: Double, longitude: Double) {
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.NotDetermined {
            locationManager.requestAlwaysAuthorization()
            setAlarm(latitude, longitude: longitude)
        }else if status == CLAuthorizationStatus.Restricted {
            let alertController = UIAlertController(
                title: "Location Serivices not avialble",
                message: "It seems you can't access Location Services on your phone",
                preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Go Back", style: .Cancel) {[weak self] (action) in
                if let weakself = self {
                    weakself.navigationController?.viewControllers.removeLast()
                }
            }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else if status == CLAuthorizationStatus.Denied || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            let alertController = UIAlertController(
                title: "Requires Access to Location",
                message: "In order to use this feature,you need to enable Always Authorized Location Service",
                preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else {
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude,longitude: longitude), radius: (setAlarmAt*1000.0), identifier: "StationRadius")
            locationManager.startMonitoringForRegion(region)
            print("Okay")
            
        }
        
    }
    @IBAction func switchOffMonitering() {
        if !self.locationManager.monitoredRegions.isEmpty {
            self.displayForSwitchOffMoniteringLabel.hidden = false
            print(self.locationManager.monitoredRegions.count)
            for eachRegion in self.locationManager.monitoredRegions {
                locationManager.stopMonitoringForRegion(eachRegion)
            }
            UIView.animateWithDuration(0, delay: 5.0, options: .CurveLinear, animations: { [weak self] in
                if let weakself = self {
                    weakself.displayForSwitchOffMoniteringLabel.hidden = true
                }
            }, completion: nil)
        }else {
            self.switchLocationSwitch.setOn(false, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // Alert user here and stop monitering for location
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
