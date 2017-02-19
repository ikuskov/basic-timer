//
//  MultiSetExcercise.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import Foundation

class Routine: NSObject, NSCoding {
  var name: String = ""
  var excerciseSets: [TimedSet]
  
  // MARK: Archiving path
  
  static let DocumentsDerictory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiveURL = DocumentsDerictory.appendingPathComponent("routines")
  
  init?(name: String?, excerciseSets: [TimedSet]) {
    self.name = name ?? "Fucking around"
    self.excerciseSets = excerciseSets
    
    super.init()
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
  
  // MARK: Types
  
  struct Property {
    static let name = "name"
    static let excerciseSets = "excerciseSets"
  }
  
  // MARK: NSCoding
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: Property.name)
    aCoder.encode(excerciseSets, forKey: Property.excerciseSets)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    let name = aDecoder.decodeObject(forKey: Property.name) as! String
    let excerciseSets = aDecoder.decodeObject(forKey: Property.excerciseSets) as! [TimedSet]
    if excerciseSets.count == 0 {
      return nil
    }
    
    self.init(name: name, excerciseSets: excerciseSets)
  }

}
