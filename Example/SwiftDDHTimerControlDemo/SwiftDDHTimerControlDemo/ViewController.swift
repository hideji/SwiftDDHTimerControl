//
//  ViewController.swift
//  SwiftDDHTimerControlDemo
//
//  Created by hideji on 2014/10/18.
//  Copyright (c) 2014 hideji. All rights reserved.
//

import UIKit
import SwiftDDHTimerControl

class ViewController: UIViewController {

    let timerControl1 = SwiftDDHTimerControl(frame: CGRectMake(0, 20, 200, 200))
    var endDate = NSDate(timeIntervalSinceNow: 12.0*60.0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timerControl1.setTranslatesAutoresizingMaskIntoConstraints(false)
        timerControl1.color = UIColor.greenColor()
        timerControl1.highlightColor = UIColor.yellowColor()
        timerControl1.minutesOrSeconds = 59
        timerControl1.titleLabel.text = "sec"
        view.addSubview(timerControl1)
        
        NSTimer.scheduledTimerWithTimeInterval( 0.1, target:self, selector: Selector("changeTimer:"), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func changeTimer(timer:NSTimer) {

        var timeInterval = self.endDate.timeIntervalSinceNow;
        self.timerControl1.minutesOrSeconds = Int(timeInterval % 60)
    }

}

