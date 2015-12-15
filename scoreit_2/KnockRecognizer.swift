//
//  KnockRecognizer.swift
//  scoreit_2
//
//  Created by Sridhar Sirasani on 11/12/2015.
//  Copyright © 2015 Sridhar Sirasani. All rights reserved.
//

import Foundation
import CoreMotion

public class KnockRecognizer{
    
    weak var delegate: KnockRecognizerDelegate?
    
    private unowned var mAccelSpikeDetector: AccelSpikeDetector
    private var eventGen: NSTimer?
    private let maxTimeBetweenEvents:Int = 25
    
    init(deviceManager: CMMotionManager){
        mAccelSpikeDetector = AccelSpikeDetector(deviceManager: deviceManager)
        mAccelSpikeDetector.resumeAccSensing()
        // Initialize the timer
        NSTimer.scheduledTimerWithTimeInterval(25, target: self, selector: "eventGenerator", userInfo: nil, repeats: true)
    }
    
    private enum EventGenState_t {
        case NoneSet, VolumSet, AccelSet
    }
    
    private func eventGenerator(){
        var nTicks: Int = 0
        var state = EventGenState_t.NoneSet
        switch state {
            case .NoneSet:
                if mAccelSpikeDetector.spikeDetected{
                    mAccelSpikeDetector.spikeDetected = false
                    state = EventGenState_t.NoneSet
                    // Generate Knock Event
                    
            }
            nTicks = 0
        }
    }
}
