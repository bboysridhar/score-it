//
//  ViewController.swift
//  scoreit_2
//
//  Created by Sridhar Sirasani on 30/11/2015.
//  Copyright © 2015 Sridhar Sirasani. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreMotion

class ViewController: UIViewController, KnockRecognizerDelegate {
    // MARK: Properties
    //var scoreItKnockDetector: KnockDetector = KnockDetector()
    @IBOutlet weak var knockLabel: UILabel!
    @IBOutlet weak var freqLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    private let motionManager = CMMotionManager()
    
    @IBAction func slider(sender: UISlider) {
//        self.scoreItKnockDetector.setIsOn(false)
//        self.scoreItKnockDetector.alg = hpf()
//        let currentValue = fabs(Double(slider.value))
//        self.scoreItKnockDetector.setCutOffFrequency(currentValue)
//        freqLabel.text = "\(currentValue)"
//        self.scoreItKnockDetector.setIsOn(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.knockLabel.alpha = 0
        self.slider.alpha = 0
        //self.scoreItKnockDetector.delegate = self
        let k = KnockRecognizer(self.motionManager)
        k.delegate = self
        //let a = AccelSpikeDetector(deviceManager: self.motionManager)
        //a.resumeAccSensing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func knockDetected(knockCount: Int){
        self.knockLabel.text = "Score : \(knockCount)"
        self.knockLabel.alpha = 1
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        UIView.animateWithDuration(0.6, delay: 0.1, options: [.AllowUserInteraction, .CurveEaseOut], animations: {
                    () -> Void in
                        self.knockLabel.alpha = 0
                    }, completion: nil)
    }

//    func knockDetectorDetectedKnock(detector: KnockDetector, atTime time: NSTimeInterval){
//        self.knockLabel.alpha = 1
//        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//        UIView.animateWithDuration(0.6, delay: 0.1, options: [.AllowUserInteraction, .CurveEaseOut], animations: {
//            () -> Void in
//                self.knockLabel.alpha = 0
//            }, completion: nil)
//    
//        NSLog("Knock detected! at time %f", time);
//    }
}

