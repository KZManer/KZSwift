//
//  KTimer.swift
//  KZSwift
//
//  Created by J+ on 2022/6/15.
//

import Foundation

class KTimer {
    static let shared = KTimer()
    private init() {}
    
    var thread  : Thread?
    var timer   : Timer?
    
    func startCountdown(duration: Int, handler:@escaping (_ countdown: Int, _ finish: Bool) -> Void) {
        
        stopCountdown()
        
        DispatchQueue.global().async {
            
            self.thread = Thread.current
            
            var count = duration
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                count -= 1
                KLog(message: "\(Thread.current) - \(count)")
                DispatchQueue.main.async {
                    handler(count,false)
                }
                if count == 0 {
                    CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), timer, .defaultMode)
                    CFRunLoopStop(CFRunLoopGetCurrent())
                    self.timer = nil
                    self.thread = nil
                    DispatchQueue.main.async {
                        handler(count,true)
                    }
                }
            }
            RunLoop.current.add(self.timer!, forMode: .common)
            CFRunLoopRun()
        }
    }
    func stopCountdown() {
        if let tim = timer {
            tim.invalidate()
            timer = nil
        }
        if let _ = thread {
            thread = nil
        }
    }
}
