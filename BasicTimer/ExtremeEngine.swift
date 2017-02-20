//
//  ExtremeEngine.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 2/19/17.
//  Copyright © 2017 Ivan Kuskov. All rights reserved.
//

import UIKit
import AVFoundation

class ExtremeEngine {
  // MARK: Singletone part
  
  static var instance: ExtremeEngine?
  
  private init() {}
  
  static func getInstance() -> ExtremeEngine {
    if instance == nil {
        instance = ExtremeEngine()
    }
    return instance!
  }
  
  // MARK: Variables
  
  var routine: Routine?
  var setInProgress: TimedSet?
  var timer: Timer?
  var delegate: ExtremeEngineDelegate?
  var isRunning: Bool = false
  
  func getNextSet() -> TimedSet? {
    for timedSet in routine!.excerciseSets {
      if timedSet.timeLeft > 0 {
        return timedSet
      }
    }
    return nil
  }
  
  @objc private func handleOneTick() {
    print("handleOneTick")
    let currentTime = Int(NSDate().timeIntervalSince1970)
    let setInProgress = self.setInProgress!
    if setInProgress.isRunning {
      let timeDelta = currentTime - setInProgress.timeStarted
      setInProgress.timeLeft -= timeDelta
      setInProgress.timeStarted = currentTime
    }
    if setInProgress.timeLeft < 3 {
      playSound()
    }
    delegate?.stateHasUpdated()
    if setInProgress.timeLeft == 0 {
      setInProgress.timeComplete = currentTime
      setInProgress.timeStopped = currentTime
      setInProgress.isRunning = false
      let nextSet = getNextSet()
      if nextSet == nil {
        stopTimer()
      } else {
        self.setInProgress = nextSet!
        self.setInProgress?.isRunning = true
        self.setInProgress?.timeStarted = currentTime
      }
    }
  }
  
  func playSound() {
    // create a sound ID, in this case its the tweet sound.
    let systemSoundID = 1016
    
    // to play sound
    AudioServicesPlaySystemSound(SystemSoundID(systemSoundID))
  }
  
  // MARK: Public API
  
  func select(routine: Routine) {
    if self.routine !== routine {
      print("Stopping timer")
      stopTimer()
    }
    self.routine = routine
    setInProgress = getNextSet()!
  }
  
  // Start/pause currently going timer
  func toggleTimer() {
    let currentTime = Int(NSDate().timeIntervalSince1970)
    isRunning = !isRunning
    setInProgress?.isRunning = !(setInProgress?.isRunning)!
    setInProgress?.timeStarted = currentTime
    handleOneTick()
    if timer === nil {
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handleOneTick), userInfo: nil, repeats: true)
    } else {
      timer?.invalidate()
      timer = nil
    }
  }
  
  // Completely stop timer and reset everything
  func stopTimer() {
    if timer == nil {
      return //  Timer is not running - nothing to stop
    }
    isRunning = false
    timer?.invalidate()
    timer = nil
    for timedSet in routine!.excerciseSets {
      timedSet.isRunning = false
      timedSet.timeLeft = timedSet.duration
    }
    setInProgress = getNextSet()!
    delegate?.stateHasUpdated()
  }
}
