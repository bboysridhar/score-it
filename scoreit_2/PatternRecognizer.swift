//
//  PatternRecognizer.swift
//  scoreit_2
//
//  Created by Sridhar Sirasani on 11/12/2015.
//  Copyright © 2015 Sridhar Sirasani. All rights reserved.
//

import Foundation

public class PatternRecognizer{
    
    private let minWaitTime_ms:NSTimeInterval = 150 // The time-window when knocks will NOT be acknowledged
    private let waitWindow_ms:NSTimeInterval = 500 // The time-window when knocks WILL be acknowledged
    
    private unowned var kRecognizer: KnockRecognizer
    private var detectedKnockCount:Int = 0
    
    init(parent: KnockRecognizer){
        kRecognizer = parent
    }
    private enum EventGenState_t {
        case Wait, S1, S2, S3, S4
    }
    
}
