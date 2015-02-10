//
//  HealthKit.swift
//  Step Counter
//
//  Created by Mani on 09.02.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

import Foundation
import HealthKit

class Health {
    // MARK: - Private vars
    private let hkStore = HKHealthStore()
    
    private var sampleTypes = NSSet(array: [
        HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount),
        HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning),
        HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierFlightsClimbed)
    ])
    
    // MARK: - Private functions
    private func isHealthKitAvailable(completion: Bool -> Void) {
        if !HKHealthStore.isHealthDataAvailable() {
            return completion(false)
        }
        
        hkStore.requestAuthorizationToShareTypes(NSSet(), readTypes: sampleTypes) { success, error in
            return completion((success == false || error != nil) ? false : true)
        }
    }
    
    private func query(sampleTypeIdentifier: String, startDate: NSDate, endDate: NSDate, unit: HKUnit, completion: Double? -> Void) {
        isHealthKitAvailable {
            if !$0 {
                return completion(nil)
            }
            
            let sampleType = HKSampleType.quantityTypeForIdentifier(sampleTypeIdentifier)
            let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: nil)
            
            let query = HKStatisticsQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .CumulativeSum) { query, statistics, error in
                if error != nil {
                    return completion(nil)
                }
                
                if let quantity = statistics.sumQuantity() {
                    return completion(quantity.doubleValueForUnit(unit))
                }
                
                return completion(0.0)
            }
            
            self.hkStore.executeQuery(query)
        }
    }
    
    // MARK: - Public functions
    func querySteps(#fromDateTime: NSDate, toDateTime: NSDate, callback: (Double?) -> Void) {
        query(HKQuantityTypeIdentifierStepCount, startDate: fromDateTime, endDate: toDateTime, unit: HKUnit.countUnit()) {
            callback($0)
        }
    }
    
    func queryTrack(#fromDateTime: NSDate, toDateTime: NSDate, callback: (Double?) -> Void) {
        query(HKQuantityTypeIdentifierDistanceWalkingRunning, startDate: fromDateTime, endDate: toDateTime, unit: HKUnit(fromString: "km")) {
            callback($0)
        }
    }
    
    func queryFlightsClimbed(#fromDateTime: NSDate, toDateTime: NSDate, callback: (Double?) -> Void) {
        query(HKQuantityTypeIdentifierFlightsClimbed, startDate: fromDateTime, endDate: toDateTime, unit: HKUnit.countUnit()) {
            callback($0)
        }
    }
}