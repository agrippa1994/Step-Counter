//
//  TableViewController.swift
//  Step Counter
//
//  Created by Mani on 28.10.14.
//  Copyright (c) 2014 Mani. All rights reserved.
//

import UIKit
import HealthKit

class TableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, DateViewControllerDelegate {
    // MARK: - Storyboard outlets
    @IBOutlet var startCell: UITableViewCell!
    @IBOutlet var endCell: UITableViewCell!
    @IBOutlet var stepCell: UITableViewCell!
    @IBOutlet var trackCell: UITableViewCell!
    @IBOutlet var flightsCell: UITableViewCell!
    
    // MARK: - Instance vars
    let health = Health()
    
    // MARK: - Storyboard actions
    @IBAction func onRefresh(sender: UIRefreshControl) {
        queryAll()
        sender.endRefreshing()
    }
    
    // MARK: - Overrided base methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshEndAndStartCells()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive"), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    
        if let vc = segue.destinationViewController as? DateViewController {
            switch sender as UITableViewCell {
            case startCell:
                vc.date = Stats.startDate
            case endCell:
                vc.date = Stats.endDate
            default:
                break
            }
            
            vc.sender = sender
            vc.delegate = self
            
            vc.presentationController?.delegate = self
            vc.popoverPresentationController?.delegate = self
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Costum selectors
    func applicationDidBecomeActive() {
        queryAll()
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

    // MARK: - DateViewControllerDelegate
    func dateViewController(controller: DateViewController, didChangedDate date: NSDate) {
        if let cell = controller.sender as? UITableViewCell {
            switch cell {
            case startCell:
                Stats.startDate = controller.date
            case endCell:
                Stats.endDate = controller.date
            default:
                break
            }
        }
        
        self.refreshEndAndStartCells()
        self.queryAll()
    }
    

    // MARK: - Methods
    func querySteps() {
        self.health.querySteps(fromDateTime: Stats.startDate, toDateTime: Stats.endDate) { steps in
            dispatch_async(dispatch_get_main_queue()) {
                if steps != nil {
                    self.stepCell.detailTextLabel?.text = String(format: "%.0f", steps!)
                }
            }
        }
    }
    
    func queryTrack() {
        self.health.queryTrack(fromDateTime: Stats.startDate, toDateTime: Stats.endDate) { track in
            dispatch_async(dispatch_get_main_queue()) {
                if track != nil {
                    self.trackCell.detailTextLabel?.text = String(format: "%.3f", track!)
                }
            }
        }
    }
    
    func queryFlights() {
        self.health.queryFlightsClimbed(fromDateTime: Stats.startDate, toDateTime: Stats.endDate) { flights in
            dispatch_async(dispatch_get_main_queue()) {
                if flights != nil {
                    self.flightsCell.detailTextLabel?.text = String(format: "%.0f", flights!)
                }
            }
        }
    }
    
    func queryAll() {
        self.querySteps()
        self.queryTrack()
        self.queryFlights()
        
        AppDelegate.sharedDelegate.loadHealthData { success in return }
    }
    
    func refreshEndAndStartCells() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        self.startCell.textLabel?.text = formatter.stringFromDate(Stats.startDate)
        self.endCell.textLabel?.text = formatter.stringFromDate(Stats.endDate)
    }
}
