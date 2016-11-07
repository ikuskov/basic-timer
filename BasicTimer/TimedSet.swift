//
//  TimedSet.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import Foundation

class TimedSet: Equatable {
  var name: String = ""
  var repsCount: Int?
  var weight: Int?
  var duration: Int = 0
  
  init?(name: String, repsCount: Int?, weight: Int?, duration: Int) {
    self.name = name
    self.repsCount = repsCount
    self.weight = weight
    self.duration = duration
  }
  
  func getDescription() -> String {
    var desc = ""
    if (weight != nil) {
      if weight == 0 {
        desc += "body"
      } else {
        desc += String(format: "%i lb", weight!)
      }
    }
    
    if (repsCount != nil) {
      desc += String(format: "/%i reps", repsCount!)
    }
    
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
}
