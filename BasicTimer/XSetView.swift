//
//  XSetView.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 2/19/17.
//  Copyright © 2017 Ivan Kuskov. All rights reserved.
//

import UIKit

class XSetView: UITableViewCell {
  
  var xset: TimedSet?
  
  @IBOutlet weak var xSetLabel: UILabel!
  
  func setXSet(timedSet: TimedSet) {
    xset = timedSet
  }
}
