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
  
  /*
    Return Groups - sets of the same excercise
  */
  func getGroups() -> Array<Array<TimedSet>> {
    var groups = [[TimedSet]]()
    var group = [TimedSet]()
    var currentSet = excerciseSets[0]
    
    for (_, ts) in excerciseSets.enumerated() {
      if ts == currentSet {
        group.append(ts)
      } else {
        groups.append(group)
        group = [TimedSet]()
      }
      currentSet = ts
    }
    
    // Don't forget about last group!
    if group.count > 0 {
      groups.append(group)
    }
    
    return groups
  }
}
