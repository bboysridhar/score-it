//
//  KnockDetector.swift
//  scoreit_2
//
//  Created by Sridhar Sirasani on 1/12/2015.
//  Copyright © 2015 Sridhar Sirasani. All rights reserved.
//
import Foundation
import CoreMotion

struct hpf {
    var alpha: Double, Yi: Double, Yim1: Double, Xi: Double, Xim1: Double, delT:Double, fc:Double,minAccel: Double
    var minKnockSeparation: NSTimeInterval, lastKnock: NSTimeInterval
    
    init(){
        alpha = 0.0
        Yi = 0.0
        Yim1 = 0.0
        Xi = 0.0
        Xim1 = 0.0
        delT = 0.0
        fc = 0.0
        minAccel = 0.0
        minKnockSeparation = 0.0
        lastKnock = 0.0
    }
}

protocol KnockDetectorDelegate: class {
    func knockDetectorDetectedKnock(detector: KnockDetector, atTime time: NSTimeInterval)
}
/// A simple detector for physical knocks, tuned for the Z-axis of iPhone 5s and 6 devices. Just set `delegate` and `isOn` to receive Knock events.
///
/// HTKnockDetector can even run in background, depending on your background modes! You will need to set `isOn = false`, and then `isOn = true` after backgrounding for Core Motion to send the detector events during background operation.
class KnockDetector {
    var alg: hpf
    weak var delegate: KnockDetectorDelegate?
    ///the accelerometer, a protected property, exposed here for Mock testing
    lazy var motionManager = CMMotionManager()
    
    var isOn: Bool
    
    init(){
        self.isOn = false
        self.alg = hpf()
        self.tuneAlgorithmToCutoffFrequency(15.0, minimumAcceleration: 0.75, minimumKnockSeparation: 0.1)
    }
    
    func setIsOn(isOn: Bool){
        if isOn != self.isOn {
            isOn ? self._start() : self._stop()
        }
        self.isOn = isOn
    }
    
    /**
     Tunes algorithm.
     @param fc The cutoff frequency for the algorithm. Default 15.0. The frequency of an average knock is 20, as the maximum interval of the knocks I saw in tests was .05s. At 15, it slightly overdetects, at 20 it underdetects, which I bet would get people to conform to the algorithm if they have feedback.
     @param minAccel The minimum acceleration to trigger a knock event. Default 0.75f(G).
     @param separation The minimum time separation between detected knock events. Default 0.1f(s).
     */
    
    func tuneAlgorithmToCutoffFrequency(fc: Double, minimumAcceleration minAccel: Double, minimumKnockSeparation separation: Double) {
        let delT: Double = self.motionManager.deviceMotionUpdateInterval
        alg.delT = delT
        alg.fc = fc
        let RC: Double = 1.0 / (2 * M_PI * fc)
        let alpha: Double = RC / (RC + delT)
        alg.alpha = alpha
        alg.minAccel = minAccel
        alg.minKnockSeparation = separation
    }
    
    func processNextMotion(motion: CMDeviceMotion) {
        let newZ: Double = motion.userAcceleration.z
        alg.Xim1 = alg.Xi
        alg.Xi = newZ
        alg.Yim1 = alg.Yi
        alg.Yi = alg.alpha * alg.Yim1 + alg.alpha * (alg.Xi - alg.Xim1)
        if fabs(alg.Yi) > alg.minAccel {
            if fabs(alg.lastKnock - motion.timestamp) > alg.minKnockSeparation {
                alg.lastKnock = motion.timestamp
                self.delegate!.knockDetectorDetectedKnock(self, atTime: motion.timestamp)
            }
        }
    }
    
    func _start() {
        let weakSelf: KnockDetector = self
        if self.motionManager.deviceMotionAvailable {
            self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(data: Optional<CMDeviceMotion>, error: Optional<NSError>) -> Void in
                weakSelf.processNextMotion(data!)
            })
        }
    }
    
    func _stop() {
        self.motionManager.stopDeviceMotionUpdates()
    }
}
