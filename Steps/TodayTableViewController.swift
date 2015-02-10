//
//  TodayViewController.swift
//  Steps
//
//  Created by Mani on 02.01.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayTableViewController: UITableViewController, NCWidgetProviding {
    
    // MARK: - Storyboard outlets
    @IBOutlet var sinceCell: UITableViewCell!
    @IBOutlet var stepsCell: UITableViewCell!
    @IBOutlet var trackCell: UITableViewCell!
    @IBOutlet var flightsCell: UITableViewCell!
    
    // MARK: - Overrided base methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.showData()
        self.preferredContentSize.height = 175.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onDefaultsChange"), name:
            NSUserDefaultsDidChangeNotification, object: nil)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    // MARK: - NCWidgetProviding
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // MARK: - Methods
    func showData() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        let dataSince = NSLocalizedString("DATA_SINCE", comment: "Data since")
        
        self.sinceCell.textLabel?.text = dataSince + " " + "\(formatter.stringFromDate(Stats.startDate))"
        self.stepsCell.detailTextLabel?.text = String(format: "%.0f", Stats.steps)
        self.trackCell.detailTextLabel?.text = String(format: "%.3f km", Stats.track)
        self.flightsCell.detailTextLabel?.text = String(format: "%.0f", Stats.flights)
    }
    
    // MARK: - Selectors
    func onDefaultsChange() {
        showData()
    }
}
