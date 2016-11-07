//
//  MultiSetExcercise.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import Foundation

class Routine {
  var name: String = ""
  var excerciseSets: [TimedSet]
  
  init?(name: String?, excerciseSets: [TimedSet]) {
    self.name = name ?? "Fucking around"
    self.excerciseSets = excerciseSets
  }
  
  func getDescription() -> String {
    let timedSet = excerciseSets[0]
    return String(format: "%@ x %i sets", timedSet.getDescription(), excerciseSets.count)
  }
}
