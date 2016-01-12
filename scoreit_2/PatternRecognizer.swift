//
//  PatternRecognizer.swift
//  scoreit_2
//
//  Created by Sridhar Sirasani on 11/12/2015.
//  Copyright © 2015 Sridhar Sirasani. All rights reserved.
//

import Foundation

public class PatternRecognizer: NSObject{
    
    private let minWaitTime_s:NSTimeInterval = 0.15 // 150 milliseconds
    //The time-window when knocks will NOT be acknowledged
    private let waitWindow_s:NSTimeInterval = 0.5 // 500 milliseconds
    // The time-window when knocks WILL be acknowledged
    
    private var timerFuture: NSTimer?
    private var state: EventGenState_t = EventGenState_t.Wait
    private unowned var kRecognizer: KnockRecognizer
    private var detectedKnockCount:Int = 0
    
    init(_ parent: KnockRecognizer){
        kRecognizer = parent
    }
    
    private enum EventGenState_t {
        case Wait, S1, S2, S3, S4
    }
    
    private func startTimer(timeToWait: NSTimeInterval){
        if timerFuture != nil && timerFuture!.valid{
            timerFuture!.invalidate()
        }
        
        timerFuture = NSTimer.scheduledTimerWithTimeInterval(timeToWait, target: self, selector: "timeOutEvent:", userInfo: nil, repeats: true)
    }
    
    func knockEvent(){
        NSLog("Pattern Recognizer: knock event \(state)")
        
        switch state{
        case .Wait:
            detectedKnockCount++
            startTimer(minWaitTime_s)
            state = .S1
        case .S1:
            //Do nothing, ignore knock
            break;
        case .S2, .S3:
            detectedKnockCount++
            startTimer(minWaitTime_s)
            state = .S3
        case .S4:
            if timerFuture != nil {
                timerFuture!.invalidate()
            }
            kRecognizer.delegate!.knockDetected(++detectedKnockCount)
            detectedKnockCount = 0
            state = .Wait
        }
    }
    
    // @objc decoration to let objective-c base access the private function
    @objc private func timeOutEvent(timerFireMethod: NSTimer){
        NSLog("Pattern Recognizer: timeoutevent: KnockCount : \(detectedKnockCount)")
        
        switch state{
        case .Wait:
            //NSLog("Pattern Recognizer: timeoutevent : Error2")
            break
        case .S1:
            startTimer(waitWindow_s)
            state = .S2
        case .S2:
            //detectedKnockCount = 0
            //state = .Wait
            startTimer(waitWindow_s)
            state = .S3
        case .S3:
            startTimer(waitWindow_s)
            state = .S4
        case .S4:
            kRecognizer.delegate!.knockDetected(detectedKnockCount)
            detectedKnockCount = 0
            state = .Wait
        }
    }
    
}
