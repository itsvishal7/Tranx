//
//  InfoTrainViewController.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/16/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import UIKit

class InfoTrainViewController: UIViewController {

    @IBOutlet weak var trainNumberLabel: UILabel! {
        didSet {
                self.trainNumberLabel.text = self.train.trainNumber
        }
    }
    @IBOutlet weak var trainNameLabel: UILabel! {
        didSet {
                self.trainNameLabel.text = self.train.trainName
        }
    }
    @IBOutlet weak var runsOnLabel: UILabel! {
        didSet {
            for each in self.train.runsOn {
                self.runsOnLabel.text = self.runsOnLabel.text! + each + " "
            }
        }
    }
    
    var train: Keys.TrainKeys!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
