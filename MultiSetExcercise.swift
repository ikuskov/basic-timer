//
//  MultiSetExcercise.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import Foundation

class MultiSetExcercise {
  var name: String = ""
  var excerciseSets: [TimedSet]?
  
  init?(name: String, excerciseSets: [TimedSet]?) {
    self.name = name
    self.excerciseSets = excerciseSets
  }
}
