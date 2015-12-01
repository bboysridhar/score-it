//
//  ViewController.swift
//  scoreit_2
//
//  Created by Sridhar Sirasani on 30/11/2015.
//  Copyright © 2015 Sridhar Sirasani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KnockDetectorDelegate {
    // MARK: Properties
    
    var scoreItKnockDetector: KnockDetector = KnockDetector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.scoreItKnockDetector.delegate = self
        self.scoreItKnockDetector.setIsOn(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func knockDetectorDetectedKnock(detector: KnockDetector, atTime time: NSTimeInterval){
        NSLog("Knock detected! at time %f", time);
    }
}

