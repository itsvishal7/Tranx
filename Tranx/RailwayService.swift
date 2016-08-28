//
//  RailwayService.swift
//  Tranx
//
//  Created by Vishal Chaurasia on 8/12/16.
//  Copyright © 2016 Vishal Chaurasia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class RailwayService {
    class func fetchLiveTrainStatus(number: Int, doj:Int, completionHandler: (Keys.LiveTrainKeys?,Int) -> Void) {
        Alamofire.request(.GET, Resources.url+"live/train/\(number)/doj/\(doj)/apikey/"+Resources.apikey).validate().responseJSON { 
            let json = JSON($0.result.value!)
            print(json)
            
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.MediumStyle
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            
            if json["response_code"].int! == 200 {
                var stations = [String]()
                var eta = [String]()
                for eachRoute in json["route"].array! {
                    if !eachRoute["has_departed"].bool! {
                        stations.append((eachRoute["station_"]["name"].string!))
                        eta.append(eachRoute["actarr"].string!)
                    }
                }
                completionHandler(Keys.LiveTrainKeys(trainNumber: json["train_number"].string!, currentTime: formatter.stringFromDate(currentDateTime), status: json["position"].string!, startDate: json["start_date"].string!, remainingStations: stations, estimatedTime: eta),200)
                print("Completed")
            }else {
                completionHandler(nil, json["response_code"].int!)
            }
        }
    }
    
    class func fetchTrainsPassingBy(stationCode: String, completionHandler: (Keys.TrainsPassingBy?,Int) -> Void) {
        Alamofire.request(.GET, Resources.url+"arrivals/station/\(stationCode)/hours/2/apikey/"+Resources.apikey).validate().responseJSON {
            let json = JSON($0.result.value!)
            print(json)
            
            if json["response_code"].int! == 200 && json["total"].int! != 0 {
                var trainNumber = [String]()
                var trainName = [String]()
                var delayOrNoDelay = [String]()
                var expArrival = [String]()
                var expDeparture = [String]()
                var schArrival = [String]()
                var schDeparture = [String]()
                for eachTrain in json["train"].array! {
                    trainNumber.append(eachTrain["number"].string!)
                    trainName.append(eachTrain["name"].string!)
                    delayOrNoDelay.append(eachTrain["delayarr"].string!)
                    expArrival.append(eachTrain["actarr"].string!)
                    expDeparture.append(eachTrain["actdep"].string!)
                    schArrival.append(eachTrain["scharr"].string!)
                    schDeparture.append(eachTrain["schdep"].string!)
                }
                completionHandler(Keys.TrainsPassingBy(trainNumber: trainNumber,trainName: trainName,delayOrNoDelay: delayOrNoDelay,scheduledArrivalAt: schArrival, expectedArrivalAt: expArrival, scheduledDepartureAt: schDeparture,expectedDepartureAt: expDeparture), 200)
                
            }else if json["total"].int! != 0 {
                completionHandler(nil,0)
            }else {
                completionHandler(nil, json["response_code"].int!)
            }
        }
    }
    
    class func fetchTrainsBetweenTwoStations(source: String, destination: String,date: String,month: String, completionHandler: (Keys.TrainsListKeys?,Int)->Void){
        Alamofire.request(.GET, Resources.url+"between/source/\(source)/dest/\(destination)/date/\(date)-\(month)/apikey/\(Resources.apikey)/").validate().responseJSON {
            let json = JSON($0.result.value!)
            print(json)
            
            if json["response_code"].int! == 200 && json["total"].int! != 0 {
                var trainNumber = [String]()
                var trainName = [String]()
                var fromStation = [String]()
                var toStation = [String]()
                var departSource = [String]()
                var arrivalSource = [String]()
                var coaches = [[String]]()
                var runningDays = [[String]]()
                for eachTrain in json["train"].array! {
                    trainNumber.append(eachTrain["number"].string!)
                    trainName.append(eachTrain["name"].string!)
                    fromStation.append(eachTrain["from"]["name"].string!)
                    toStation.append(eachTrain["to"]["name"].string!)
                    departSource.append(eachTrain["src_departure_time"].string!)
                    arrivalSource.append(eachTrain["dest_arrival_time"].string!)
                    var coach = [String]()
                    for each in eachTrain["classes"].array! {
                        if each["available"].string! == "Y" {
                            coach.append(each["class-code"].string!)
                        }
                    }
                    coaches.append(coach)
                    var day = [String]()
                    for each in eachTrain["days"].array! {
                        if each["runs"].string! == "Y" {
                            day.append(each["day-code"].string!)
                        }
                    }
                    runningDays.append(day)
                }
                completionHandler(Keys.TrainsListKeys(trainNumber: trainNumber, trainName: trainName,fromStation: fromStation,toStation: toStation,coaches: coaches,days: runningDays,sourceDepartureTime: departSource,destinationArrivalTime: arrivalSource), 200)
            }else if json["total"].int! != 0 {
                completionHandler(nil,0)
            }else {
                completionHandler(nil, json["response_code"].int!)
            }
        }
    }
    
    class func fetchTrainData(trainNumber: String, completionHandler: (Keys.TrainKeys?,Int)->Void) {
        Alamofire.request(.GET, Resources.url+"name_number/train/\(trainNumber)/apikey/"+Resources.apikey).validate().responseJSON {
            let json = JSON($0.result.value!)
            print(json)
            
            if json["response_code"].int! == 200 {
                var runOn = [String]()
                for each in json["train"]["days"].array! {
                    if each["runs"].string! == "Y" {
                        runOn.append(each["day-code"].string!)
                    }
                }
                completionHandler(Keys.TrainKeys(trainNumber: trainNumber,trainName: json["train"]["name"].string!, runsOn: runOn), 200)
            }else {
                completionHandler(nil, json["response_code"].int!)
            }
        }
    }
    
    class func fetchLocationCoordinates(station: String, completionHandler: (Keys.AlarmKeys?,Int)->Void) {
        Alamofire.request(.GET, Resources.url+"code_to_name/code/\(station)/apikey/"+Resources.apikey).validate().responseJSON {
            let json = JSON($0.result.value!)
            print(json)
            
            if json["response_code"].int! == 200 {
                for eachStation in json["stations"].array! {
                    if station.localizedCaseInsensitiveContainsString(eachStation["code"].string!) {
                        completionHandler(Keys.AlarmKeys(longitude: eachStation["lng"].double!, latitude: eachStation["lat"].double!, stationName: eachStation["fullname"].string!), 200)
                    }
                }
            }else {
                completionHandler(nil, json["response_code"].int!)
            }
        }
    }
    
    class func fetchPNRStatus(pnrNumber: String, completionHandler: (Keys.PNRStatusKeys?, Int) -> Void) {
        Alamofire.request(.GET, Resources.url+"pnr_status/pnr/"+pnrNumber+"/apikey/"+Resources.apikey).validate().responseJSON {
            let json = JSON($0.result.value!)
            print(json["passengers"])
            
            if json["response_code"].int! == 200 {
                var bSts = [String]()
                var cSts = [String]()
                for each in json["passengers"].array! {
                    bSts.append(each["current_status"].string!)
                    cSts.append(each["booking_status"].string!)
                }
                completionHandler(Keys.PNRStatusKeys(pnr: json["pnr"].string!, trainNumber: json["train_num"].string!, trainName: json["train_name"].string!, date: json["doj"].string!, toStation: json["to_station"]["name"].string!, fromStation: json["boarding_point"]["name"].string!, claas: json["class"].string!, bookingStatus: bSts, currentStatus: cSts), 200)
            }else {
                completionHandler(nil, json["response_code"].int!)
            }
        }
    }
}