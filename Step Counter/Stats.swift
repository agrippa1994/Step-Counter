//
//  Stats.swift
//  Step Counter
//
//  Created by Mani on 02.01.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

import Foundation

// MARK: - Global private vars
private let suiteName = "group.StepCounter"

// MARK: - Private functions
private func read(key: String) -> AnyObject? {
    let defaults = NSUserDefaults(suiteName: suiteName)
    
    if let data = defaults?.objectForKey(key) as? NSData {
        return NSKeyedUnarchiver.unarchiveObjectWithData(data)
    }
    
    return nil
}

private func write(key: String, data: AnyObject) {
    let defaults = NSUserDefaults(suiteName: suiteName)
    let data = NSKeyedArchiver.archivedDataWithRootObject(data)
    
    defaults?.setObject(data, forKey: key)
}

class Stats {
    class var sharedDefaults: NSUserDefaults {
        return NSUserDefaults(suiteName: suiteName)!
    }
    
    class var startDate: NSDate {
        get {
            if let date = read("startDate") as? NSDate {
                return date
            }
            return NSDate()
        }
        
        set(value) {
            write("startDate", value)
        }
    }
    
    class var endDate: NSDate {
        get {
            if let date = read("endDate") as? NSDate {
                return date
            }
            return NSDate()
        }
        
        set(value) {
            write("endDate", value)
        }
    }

    
    class var steps: Double {
        get {
            if let steps = read("steps") as? Double {
                return steps
            }
            return 0
        }
        
        set(value) {
            write("steps", value)
        }
    }
    
    class var track: Double {
        get {
            if let track = read("track") as? Double {
                return track
            }
            return 0.0
        }
        
        set(value) {
            write("track", value)
        }
    }
    
    class var flights: Double {
        get {
            if let track = read("flights") as? Double {
                return track
            }
            return 0.0
        }
        
        set(value) {
            write("flights", value)
        }
    }
}