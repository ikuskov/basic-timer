//
//  TimedSet.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import Foundation

class TimedSet {
  var name: String = ""
  var repsCount: Int?
  var duration: Int = 0
  
  init?(name: String, repsCount: Int?, duration: Int) {
    self.name = name
    self.repsCount = repsCount
    self.duration = duration
  }
}
