//
//  TimedSet.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import Foundation

class TimedSet: NSObject, NSCoding, NSCopying {
  
  // MARK: NSCoding consts
  static let DocumentsDerictory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiveURL = DocumentsDerictory.appendingPathComponent("routines")
  static let SchemaVersion = "2"
  
  var name: String = ""
  var repsCount: Int
  var weight: Int
  var duration: TimeInterval = 0
  var timeStarted: TimeInterval = -1
  var timeStopped: TimeInterval = -1
  var timeComplete: TimeInterval = -1
  var timeLeft: TimeInterval = 0
  var isRunning: Bool = false
  
  init?(name: String, repsCount: Int?, weight: Int, duration: TimeInterval) {
    self.name = name
    self.repsCount = repsCount ?? 1
    self.weight = weight
    self.duration = duration
    self.timeLeft = Double(duration)
    
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
    /* Special propery to not get NSExceptions on Schema changes */
    static let schemaVersion = "timed_set_schema_version"
    
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
    print("encoding version:", TimedSet.SchemaVersion)
    aCoder.encode(TimedSet.SchemaVersion, forKey: Property.schemaVersion)
    
    aCoder.encode(name, forKey: Property.name)
    aCoder.encode(repsCount, forKey: Property.repsCount)
    aCoder.encode(weight, forKey: Property.weight)
    aCoder.encode(duration, forKey: Property.duration)
    aCoder.encode(timeStarted, forKey: Property.timeStarted)
    aCoder.encode(timeStopped, forKey: Property.timeStropped)
    aCoder.encode(timeComplete, forKey: Property.timeComplete)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    var version = aDecoder.decodeObject(forKey: Property.schemaVersion) as? String
    version = version ?? "Undefined"
    if version != TimedSet.SchemaVersion {
      self.init(coder: aDecoder, version: version!)
      return
    }
    let name = aDecoder.decodeObject(forKey: Property.name) as! String
    let repsCount = aDecoder.decodeInteger(forKey: Property.repsCount)
    let weight = aDecoder.decodeInteger(forKey: Property.weight)
    let duration = aDecoder.decodeDouble(forKey: Property.duration)
    let timeStarted = aDecoder.decodeDouble(forKey: Property.timeStarted)
    let timeStopped = aDecoder.decodeDouble(forKey: Property.timeStropped)
    let timeComplete = aDecoder.decodeDouble(forKey: Property.timeComplete)
    
    self.init(name: name, repsCount: repsCount, weight: weight, duration: TimeInterval(duration))
    self.timeStarted = timeStarted
    self.timeStopped = timeStopped
    self.timeComplete = timeComplete
  }
  
  /* For version 1 */
  convenience init?(coder aDecoder: NSCoder, version: String) {
    print("Fallback init for version: ", version)
    let name = aDecoder.decodeObject(forKey: Property.name) as! String
    let repsCount = aDecoder.decodeInteger(forKey: Property.repsCount)
    let weight = aDecoder.decodeInteger(forKey: Property.weight)
    /* Old version - begin */
    let duration = TimeInterval(aDecoder.decodeInteger(forKey: Property.duration))
    let timeStarted = Double(aDecoder.decodeInteger(forKey: Property.timeStarted))
    let timeStopped = Double(aDecoder.decodeInteger(forKey: Property.timeStropped))
    let timeComplete = Double(aDecoder.decodeInteger(forKey: Property.timeComplete))
    /* Old version - end */
    
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
