//
//  SearchTrainViewController.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/11/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import UIKit

class SearchTrainViewController: UIViewController {
    @IBOutlet weak var fromStationTextField: CustomTextField!
    @IBOutlet weak var toStationTextField: CustomTextField!
    @IBOutlet weak var journeyDateTextField: CustomTextField! {
        didSet {
            self.journeyDateTextField.delegate = self
        }
    }
    @IBOutlet weak var searchForTrainTextField: UITextField! {
        didSet {
            self.searchForTrainTextField.delegate = self
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func searchForTrainPressed() {
        
//        if self.fromStationTextField.text != nil  && self.fromStationTextField.text != "" {
//            self.fromStationTextField.shake();
//            return
//        }
//        if self.toStationTextField.text != nil && self.toStationTextField.text != "" {
//            self.toStationTextField.shake();
//            return
//        }
//        if self.journeyDateTextField.text != nil && self.journeyDateTextField.text != "" {
//            self.journeyDateTextField.shake();
//            return
//        }
        var date = self.journeyDateTextField.text!.characters.split("/")
        RailwayService.fetchTrainsBetweenTwoStations(self.fromStationTextField.text!, destination: self.toStationTextField.text! , date: String(date[0]), month: String(date[1])){[weak self] trainLists, code in
            if let weakself = self {
                weakself.view.userInteractionEnabled = true
                weakself.activityIndicator.stopAnimating()
                if code == 200 {
                    if let destinationVC = weakself.storyboard?.instantiateViewControllerWithIdentifier("showing_lists_of_trains") as? ShowingTrainsViewController {
                        destinationVC.trains = trainLists!
                        destinationVC.date = self?.journeyDateTextField.text!
                        weakself.showViewController(destinationVC, sender: nil)
                    }
                }else if code == 0 {
                    let alert = UIAlertController(title: "Zero trains", message: "There are no trains between \(weakself.fromStationTextField.text) and \(weakself.toStationTextField.text).", preferredStyle: .ActionSheet)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    weakself.presentViewController(alert, animated: true, completion: nil)
                }else if code == 204 {
                    let alert = UIAlertController(title: "❗️", message: "Network Error", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    weakself.presentViewController(alert, animated: true, completion: nil)
                }else {
                    //some other error
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
extension SearchTrainViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.journeyDateTextField {
            print("journey")
        }else if textField == self.searchForTrainTextField {
            print("search")
            RailwayService.fetchTrainData(self.searchForTrainTextField.text!, completionHandler: {[weak self] (train, code) in
                if let weakself = self {
                    weakself.view.userInteractionEnabled = true
                    weakself.activityIndicator.stopAnimating()
                    if code == 200 {
                        if let destinationVC = weakself.storyboard?.instantiateViewControllerWithIdentifier("train") as? InfoTrainViewController {
                            destinationVC.train = train!
                            weakself.showViewController(destinationVC, sender: nil)
                        }else {
                            let alert = UIAlertController(title: "❗️", message: "Network Error", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                            weakself.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                }
            })
            self.activityIndicator.hidden = false
            self.view.userInteractionEnabled = false
            self.activityIndicator.startAnimating()
        }else {
            print("Nothing")
        }
    }
}