//
//  LiveTrainKeys.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/12/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import Foundation
struct Keys {
    
    struct LiveTrainKeys{
        let trainNumber: String?
        let currentTime: String?
        let status: String?
        let startDate: String?
        let remainingStations: [String]?
        let estimatedTime: [String]?
    }
    
    struct PNRStatusKeys {
        let pnr: String
        let trainNumber: String
        let trainName: String
        let date: String
        let toStation: String
        let fromStation: String
        let claas: String
        let bookingStatus: [String]
        let currentStatus:[String]
    }
    
    struct TrainsPassingBy {
        let trainNumber: [String]
        let trainName: [String]
        let delayOrNoDelay: [String]
        let scheduledArrivalAt: [String]
        let expectedArrivalAt: [String]
        let scheduledDepartureAt: [String]
        let expectedDepartureAt: [String]
    }
    
    struct AlarmKeys {
        let longitude: Double
        let latitude: Double
        let stationName: String
    }
    
    struct TrainsListKeys {
        let trainNumber: [String]
        let trainName: [String]
        let fromStation: [String]
        let toStation: [String]
        let coaches: [[String]]
        let days: [[String]]
        let sourceDepartureTime: [String]
        let destinationArrivalTime: [String]
    }
    struct TrainKeys {
        let trainNumber: String
        let trainName: String
        let runsOn: [String]
    }
}