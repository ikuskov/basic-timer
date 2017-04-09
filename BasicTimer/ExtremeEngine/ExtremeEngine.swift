//
//  ExtremeEngine.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 2/19/17.
//  Copyright © 2017 Ivan Kuskov. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ExtremeEngine {
  // MARK: Singletone part
  
  static var instance: ExtremeEngine?
  
  private init() {
    player = getPlayer()
    player!.prepareToPlay()
  }
  
  static func getInstance() -> ExtremeEngine {
    if instance == nil {
        instance = ExtremeEngine()
    }
    return instance!
  }
  
  // MARK: Variables
  
  var routine: Routine?
  var setInProgress: TimedSet?
  var timer: DispatchSourceTimer?
  var delegate: ExtremeEngineDelegate?
  var isRunning: Bool = false
  
  var player: AVAudioPlayer?
  var players: [AVAudioPlayer] = [AVAudioPlayer]()
  var nextSoundTime: TimeInterval?
  
  func getNextSet() -> TimedSet? {
    for timedSet in routine!.excerciseSets {
      if timedSet.timeLeft > 0 {
        return timedSet
      }
    }
    return nil
  }
  
  private func scheduleSound(afterTime: Double, loops: Int = 0) {
    // For better user experience - to start playing a bit before `00:00`
    let offset = min(player!.duration / 2, 0.5)
    let playTime = player!.deviceCurrentTime + afterTime - offset
    if nextSoundTime == nil {
      nextSoundTime = playTime
    }
    if playTime != nextSoundTime {
      print("New play time", playTime)
      player?.numberOfLoops = loops
      player!.play(atTime: playTime)
    }
  }
  
  private func cancelSound() {
    player!.stop()
  }
  
  private func getPlayer() -> AVAudioPlayer? {
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//      Use https://github.com/TUNER88/iOSSystemSoundsLibrary for the list of system sounds
//      let b = Bundle.init(path: "/System/Library/Audio/UISounds/")
//      let url = b?.url(forResource: "sms_alert_bamboo", withExtension: "caf", subdirectory: "Modern")
      let b = Bundle.main
      let url = b.url(forResource: "Glass", withExtension: "aiff", subdirectory: nil)
      return try AVAudioPlayer(contentsOf: url!)
    } catch {
      print("ERROR! AVAudio had troubles initializing!")
    }
    return nil
  }
  
  private func handleOneTick() {
    let currentTime = NSDate().timeIntervalSince1970
    let setInProgress = self.setInProgress!
    if setInProgress.isRunning {
      let timeDelta = currentTime - setInProgress.timeStarted
      setInProgress.timeLeft -= timeDelta
      setInProgress.timeStarted = currentTime
      scheduleSound(afterTime: setInProgress.timeLeft)
    }
    delegate?.stateHasUpdated()
    if setInProgress.timeLeft <= 0 {
      setInProgress.timeComplete = currentTime
      setInProgress.timeStopped = currentTime
      setInProgress.isRunning = false
      let nextSet = getNextSet()
      if nextSet === nil {
        scheduleSound(afterTime: 0.0, loops: 2)
        stopTimer()
      } else {
        self.setInProgress = nextSet!
        self.setInProgress!.isRunning = true
        self.setInProgress!.timeStarted = currentTime
        scheduleSound(afterTime: self.setInProgress!.timeLeft)
      }
    }
  }
  
  private func willStartRunning() {
    handleOneTick()
    let xSet = getNextSet()
    if xSet !== nil {
      scheduleSound(afterTime: xSet!.timeLeft)
    }
  }
  
  private func willPauseRunning() {
    cancelSound()
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
    let currentTime = NSDate().timeIntervalSince1970
    isRunning = !isRunning
    setInProgress?.isRunning = !(setInProgress?.isRunning)!
    setInProgress?.timeStarted = currentTime
    if isRunning {
      willStartRunning()
    } else {
      willPauseRunning()
    }
    
    if timer === nil {
      timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
      timer!.setEventHandler(handler: {
        DispatchQueue.main.sync {
          self.handleOneTick()
        }
      })
      timer!.scheduleRepeating(deadline: DispatchTime.now(), interval: 0.25, leeway: DispatchTimeInterval.milliseconds(1))
      timer!.resume()
    } else {
      timer = nil
    }
  }
  
  // Completely stop timer and reset everything
  func stopTimer() {
    if timer == nil {
      return //  Timer is not running - nothing to stop
    }
    isRunning = false
    timer = nil
    for timedSet in routine!.excerciseSets {
      timedSet.isRunning = false
      timedSet.timeLeft = TimeInterval(timedSet.duration)
    }
    setInProgress = getNextSet()!
    delegate?.stateHasUpdated()
  }
}
