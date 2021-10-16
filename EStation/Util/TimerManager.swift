//
//  TimerManager.swift
//  EStation
//
//  Created by Freddy A. on 10/14/21.
//

import Foundation
import SwiftUI

class TimerManager: ObservableObject {
    @Published var timerMode: TimerMode = .initial
    @Published var secondsLeft = 60
    
    var timer = Timer()
    
    func start() {
        timerMode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if self.secondsLeft == 0 {
                self.pause()
                
                // Call Method API
                
                self.reset()
            }
            
            self.secondsLeft -= 1
            
            print(self.secondsLeft)
        })
    }
    
    func updateInfo(provinceId: Int?, goId: Int?) {
         
    }
    
    func reset() {
        self.timerMode = .initial
        self.secondsLeft = 60
       
    }
    
    func pause() {
        self.timerMode = .paused
    }
}
