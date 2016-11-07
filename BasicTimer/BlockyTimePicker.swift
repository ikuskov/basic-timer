//
//  BlockyTimePicker.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import UIKit

class BlockyTimePicker: UIView, UIGestureRecognizerDelegate {
  
  var duration = 60 {
    didSet {
      setNeedsLayout()
    }
  }
  
  var minuteButtons = [UIButton]()
  var secondButtons = [UIButton]()
  var delegate: BlockyTimePickerDelegate?
  
  let minuteConsts = Array(0...5)
  let secondConsts = [0, 5, 10, 15, 30, 45];
  
  let spacing = 5
  let width = 44
  let height = 44
  
  // MARK: Initialization
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    for index in 0..<minuteConsts.count {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
      let title = String(format: "%02i", minuteConsts[index])
      button.setTitle(title, for: .normal)
      button.backgroundColor = UIColor.lightGray
      button.setTitleColor(UIColor.red, for: .normal)
      button.setTitleColor(UIColor.green, for: .selected)
      button.setTitleColor(UIColor.blue, for: [.selected, .highlighted])
      button.addTarget(self, action: #selector(handleTap), for: .touchDown)
      minuteButtons += [button]
      addSubview(button)
    }
    
    for index in 0..<secondConsts.count {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
      let title = String(format: "%02i", secondConsts[index])
      button.setTitle(title, for: .normal)
      button.backgroundColor = UIColor.lightGray
      button.setTitleColor(UIColor.red, for: .normal)
      button.setTitleColor(UIColor.green, for: .selected)
      button.setTitleColor(UIColor.blue, for: [.selected, .highlighted])
      button.addTarget(self, action: #selector(handleTap), for: .touchDown)
      secondButtons += [button]
      addSubview(button)
    }
  }
  
  override func layoutSubviews() {
    var buttonFrame = CGRect(x: 0, y: 0, width: width, height: height)
    
    for (index, button) in minuteButtons.enumerated() {
      buttonFrame.origin.x = CGFloat(index * (width + spacing))
      button.frame = buttonFrame
    }
    
    for (index, button) in secondButtons.enumerated() {
      buttonFrame.origin.y = CGFloat(height + spacing)
      buttonFrame.origin.x = CGFloat(index * (width + spacing))
      button.frame = buttonFrame
    }
    
    updateButtonStates()
  }
  
  override var intrinsicContentSize: CGSize {
    let maxCount = max(minuteButtons.count, secondButtons.count)
    return CGSize(width: maxCount * (width + spacing), height: 2 * (height + spacing))
  }
  
  // MARK: Button Action
  func handleTap(_ button: UIButton) {
    var minutes = duration / 60 % 60
    var seconds = duration % 60
    if let index = minuteButtons.index(of: button) {
      minutes = minuteConsts[index]
    } else if let index = secondButtons.index(of: button) {
      seconds = secondConsts[index]
    }
    
    duration = 60 * minutes + seconds
    
    updateButtonStates()
  }
  
  func updateButtonStates() {
    delegate?.durationDidUpdate(duration)
    
    let minutes = duration / 60 % 60
    let seconds = duration % 60
    
    for (index, button) in secondButtons.enumerated() {
      button.isSelected = secondConsts[index] == seconds
    }
    
    for (index, button) in minuteButtons.enumerated() {
      button.isSelected = minuteConsts[index] == minutes
    }
  }

}
