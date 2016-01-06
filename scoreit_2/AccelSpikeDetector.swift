//
//  AccelSpikeDetector.swift
//  scoreit_2
//
//  Created by Sridhar Sirasani on 11/12/2015.
//  Copyright © 2015 Sridhar Sirasani. All rights reserved.
//

/**
* Detects spikes in accelerometer data (only in z axis) and generates accelerometer events
* the volatile spikeDetected boolean will be set when a spike is detected
*/

import Foundation
import CoreMotion
//import AudioToolbox

public class AccelSpikeDetector{

    // MARK - Properties
    var spikeDetected:Bool = false
    
    
    private unowned var deviceManager: CMMotionManager
    
    // Optimization parameters accelerometer
    //Force needed to trigger event, G = 9.81 methinks
    private let thresholdZ: Double = 3.0, threshholdX:Double = 5.0, threshholdY:Double = 5.0
    private let updateFrequency:Double = 60.0 // 60 Hz - 60 times per second
    
    //For high pass filter
    private var prevXVal:Double = 0, currentXVal:Double = 0, diffX:Double = 0
    private var prevYVal:Double = 0, currentYVal:Double = 0, diffY:Double = 0
    private var prevZVal:Double = 0, currentZVal:Double = 0, diffZ:Double = 0
    
    init(deviceManager: CMMotionManager){
        self.deviceManager = deviceManager
        self.deviceManager.deviceMotionUpdateInterval = 1.0/updateFrequency
    }
    
    public func stopAccelSensing() {
        deviceManager.stopDeviceMotionUpdates()
    }
    
    public func resumeAccSensing(){
        /*
        deviceManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
            (data: Optional<CMDeviceMotion>,error: Optional<NSError>) -> Void in
            self.onSensorChanged(data!)
        }
*/
        deviceManager.startDeviceMotionUpdatesToQueue(NSOperationQueue(), withHandler: onSensorChanged)
    }
    
    private func onSensorChanged(data: Optional<CMDeviceMotion>,error: Optional<NSError>){
        
        prevXVal = currentXVal
        currentXVal = data!.userAcceleration.x // X-axis
        diffX = currentXVal - prevXVal
        
        prevYVal = currentYVal
        currentYVal = data!.userAcceleration.y // Y-axis
        diffY = currentYVal - prevYVal
        
        prevZVal = currentZVal
        currentZVal = data!.userAcceleration.z // Z-axis
        diffZ = currentZVal - prevZVal
        
        //Z force must be above some limit, the other forces below some limit to filter out shaking motions
        if (currentZVal > prevZVal && diffZ > thresholdZ && diffX < threshholdX && diffY < threshholdY){
            accTapEvent()
        }
    }
    
    private func accTapEvent(){
        spikeDetected = true
        //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        NSLog("AccelSpikeDetector: Spike Detected")
    }
}


