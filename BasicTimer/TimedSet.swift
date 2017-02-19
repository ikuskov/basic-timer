//
//  TimedSet.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import Foundation

class TimedSet: NSObject, NSCoding, NSCopying {
  
  static let DocumentsDerictory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiveURL = DocumentsDerictory.appendingPathComponent("routines")
  
  var name: String = ""
  var repsCount: Int
  var weight: Int
  var duration: Int = 0
  var timeStarted: Int = -1
  var timeStopped: Int = -1
  var timeComplete: Int = -1
  var timeLeft: Int = 0
  var isRunning: Bool = false
  
  init?(name: String, repsCount: Int?, weight: Int, duration: Int) {
    self.name = name
    self.repsCount = repsCount ?? 1
    self.weight = weight
    self.duration = duration
    self.timeLeft = duration
    
    super.init()
  }
  
  func getDescription() -> String {
    var desc = ""
    if weight == 0 {
      desc += "body"
    } else {
      desc += String(format: "%i lb", weight)
    }
    
    desc += String(format: "/%i reps", repsCount)
    
    if desc == "" {
      return "Blank"
    }
    
    return desc
  }
  
  // MARK: Equatable
  
  static func ==(a: TimedSet, b: TimedSet) -> Bool {
    return
      a.name == b.name &&
      a.repsCount == b.repsCount &&
      a.weight == b.weight &&
      a.duration == b.duration
  }
  
  // MARK: Types
  
  struct Property {
    static let name = "name"
    static let repsCount = "reps"
    static let weight = "weight"
    static let duration = "duration"
    static let timeStarted = "started"
    static let timeStropped = "stopped"
    static let timeComplete = "complete"
  }
  
  // MARK: NSCoding
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: Property.name)
    aCoder.encode(repsCount, forKey: Property.repsCount)
    aCoder.encode(weight, forKey: Property.weight)
    aCoder.encode(duration, forKey: Property.duration)
    aCoder.encode(timeStarted, forKey: Property.timeStarted)
    aCoder.encode(timeStopped, forKey: Property.timeStropped)
    aCoder.encode(timeComplete, forKey: Property.timeComplete)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    let name = aDecoder.decodeObject(forKey: Property.name) as! String
    let repsCount = aDecoder.decodeInteger(forKey: Property.repsCount)
    let weight = aDecoder.decodeInteger(forKey: Property.weight)
    let duration = aDecoder.decodeInteger(forKey: Property.duration)
    let timeStarted = aDecoder.decodeInteger(forKey: Property.timeStarted) 
    let timeStopped = aDecoder.decodeInteger(forKey: Property.timeStropped)
    let timeComplete = aDecoder.decodeInteger(forKey: Property.timeComplete)
    
    self.init(name: name, repsCount: repsCount, weight: weight, duration: duration)
    self.timeStarted = timeStarted
    self.timeStopped = timeStopped
    self.timeComplete = timeComplete
  }
  
  // MARK: NSCopying
  
  func copy(with zone: NSZone? = nil) -> Any {
    return TimedSet(name: name, repsCount: repsCount, weight: weight, duration: duration)!
  }

  
}
