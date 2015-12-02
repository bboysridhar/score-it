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
    
    @IBOutlet weak var knockLabel: UILabel!
    var scoreItKnockDetector: KnockDetector = KnockDetector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.scoreItKnockDetector.delegate = self
        self.scoreItKnockDetector.setIsOn(true)
        self.knockLabel.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func knockDetectorDetectedKnock(detector: KnockDetector, atTime time: NSTimeInterval){
        self.knockLabel.alpha = 1
        UIView.animateWithDuration(0.6, delay: 0.1, options: [.AllowUserInteraction, .CurveEaseOut], animations: {
            () -> Void in
                self.knockLabel.alpha = 0
            }, completion: nil)
    
        NSLog("Knock detected! at time %f", time);
    }
}

