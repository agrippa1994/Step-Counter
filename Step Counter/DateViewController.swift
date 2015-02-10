//
//  DateViewController.swift
//  Step Counter
//
//  Created by Mani on 13.01.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

import UIKit

@objc protocol DateViewControllerDelegate {
    optional func dateViewController(controller: DateViewController, didChangedDate date: NSDate)
}

class DateViewController: UIViewController {
    // MARK: - Weak vars
    weak var delegate: DateViewControllerDelegate?
    weak var sender: AnyObject?
    
    // MARK: - vars
    var date = NSDate()
    
    // MARK: - Storyboard outlets
    @IBOutlet private var datePicker: UIDatePicker!
    
    // MARK: - Storyboard actions
    @IBAction private func dateChanged(sender: UIDatePicker) {
        self.date = sender.date
        self.delegate?.dateViewController?(self, didChangedDate: self.date)
    }

    // MARK: - Overrided base methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.datePicker.date = self.date
    }
}
