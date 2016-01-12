//
//  KnockRecognizer.swift
//  scoreit_2
//
//  Created by Sridhar Sirasani on 11/12/2015.
//  Copyright © 2015 Sridhar Sirasani. All rights reserved.
//

import Foundation
import CoreMotion

public class KnockRecognizer:NSObject {
    
    weak var delegate: KnockRecognizerDelegate?
    
    private var mAccelSpikeDetector: AccelSpikeDetector?
    private var mPatt: PatternRecognizer?
    private var eventGen: NSTimer?
    
    /*
        The effective resolution of the time interval for a timer is limited to on the order of 50-100 milliseconds.
    */
    private let maxTimeBetweenEvents:NSTimeInterval = 0.05 // 50 milliseconds
    
    init(_ deviceManager: CMMotionManager){
        super.init()
        
        mAccelSpikeDetector = AccelSpikeDetector(deviceManager: deviceManager)
        mAccelSpikeDetector!.resumeAccSensing()
        
        mPatt = PatternRecognizer(self)
        eventGenerator()
    }
        
    // @objc decoration to let objective-c base access the private function
    @objc private func timerTick(timerFireMethod: NSTimer){
        //generate knock event
        if mAccelSpikeDetector!.spikeDetected{
            mAccelSpikeDetector!.spikeDetected = false
            mPatt!.knockEvent()
        }
    }
    
    private func eventGenerator(){
        // TODO: Consider invalidating the timer on deinit
        NSTimer.scheduledTimerWithTimeInterval(maxTimeBetweenEvents, target: self, selector: "timerTick:", userInfo: nil, repeats: true)
        
        
    }
}
