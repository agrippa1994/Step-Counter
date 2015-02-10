//
//  AppDelegate.swift
//  Step Counter
//
//  Created by Mani on 28.10.14.
//  Copyright (c) 2014 Mani. All rights reserved.
//

import UIKit
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    class var sharedDelegate: AppDelegate {
        return UIApplication.sharedApplication().delegate! as AppDelegate
    }
    
    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window?.tintColor = UIColor.redColor()
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        self.loadHealthData { success in return }
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        self.loadHealthData {
            completionHandler($0 ? .NewData : .Failed)
        }
    }
    
    func loadHealthData(completionHandler: Bool -> Void) {
        let health = Health()
        let startDate = Stats.startDate
        let endDate = NSDate()
        
        health.querySteps(fromDateTime: startDate, toDateTime: endDate) { steps in
            if steps == nil {
                return completionHandler(false)
            }
            
            Stats.steps = steps!
            
            health.queryTrack(fromDateTime: startDate, toDateTime: endDate) { track in
                if track == nil {
                    return completionHandler(false)
                }
                
                Stats.track = track!
                
                health.queryFlightsClimbed(fromDateTime: startDate, toDateTime: endDate) { flights in
                    if flights == nil {
                        return completionHandler(false)
                    }
                    
                    Stats.flights = flights!
                    return completionHandler(true)
                }
            }
        }
    }
}

