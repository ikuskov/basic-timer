//
//  RoutineViewController.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 2/19/17.
//  Copyright © 2017 Ivan Kuskov. All rights reserved.
//

import UIKit
import AVFoundation

class RoutineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var routine: Routine?
  var timer: Timer?
  var currentSet: TimedSet!
  
  @IBOutlet weak var nameField: UILabel!
  @IBOutlet weak var setsTable: UITableView!
  @IBOutlet weak var startStopButton: UIButton!
  @IBOutlet weak var timeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
//    timePicker.delegate = self
    
    setsTable.delegate = self
    setsTable.dataSource = self
    
    if let routine = routine {
      nameField.text = routine.name
//      let timedSet = routine.excerciseSets[0]
//      print(routine.getGroups())
//      weightField.text = String(timedSet.weight)
//      repsField.text = String(timedSet.repsCount)
//      setsField.text = String(routine.excerciseSets.count)
//      timePicker.duration = timedSet.duration
//      repsStepper.value = Double(timedSet.repsCount)
//      setsStepper.value = Double(routine.excerciseSets.count)
    }
    
    currentSet = routine!.excerciseSets[0]
    
    // To hide keyboard on taps outside of text edit area
    view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view.endEditing)))
  }

  // MARK: Navigation
  
  @IBAction func handleCancel(_ sender: UIBarButtonItem) {
    let isModal = presentingViewController is UINavigationController
    if isModal {
      dismiss(animated: true, completion: nil)
    } else {
      navigationController!.popViewController(animated: true)
    }
  }
  
  func playSound() {
    // create a sound ID, in this case its the tweet sound.
    let systemSoundID = 1016
    
    // to play sound
    AudioServicesPlaySystemSound(SystemSoundID(systemSoundID))
  }
  
  func handleOneTick() {
    let currentTime = Int(NSDate().timeIntervalSince1970)
    if currentSet.isRunning {
      let timeDelta = currentTime - currentSet.timeStarted
      currentSet.timeLeft -= timeDelta
      currentSet.timeStarted = currentTime
    }
    if currentSet.timeLeft < 3 {
      playSound()
    }
    timeLabel.text = MSETableViewController.formatTime(fromSeconds: currentSet.timeLeft)
    setsTable.reloadData()
    if currentSet.timeLeft == 0 {
      currentSet.timeComplete = currentTime
      stopTimer()
    }
  }
  
  // Start/pause
  func toggleTimer() {
    let currentTime = Int(NSDate().timeIntervalSince1970)
    currentSet.isRunning = !currentSet.isRunning
    currentSet.timeStarted = currentTime
    handleOneTick()
  }
  
  func stopTimer() {
    let current_time = Int(NSDate().timeIntervalSince1970)
    currentSet.timeStopped = current_time
    currentSet.timeLeft = currentSet.duration
    currentSet.isRunning = false
    timer?.invalidate()
    timer = nil
    startStopButton.setTitle("Start!", for: UIControlState.normal)
  }
  
  @IBAction func handleStart(_ sender: Any) {
    playSound()
    print("Called handle start")
    handleOneTick()
    if timer === nil {
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handleOneTick), userInfo: nil, repeats: true)
      toggleTimer()
      startStopButton.setTitle("Stop!", for: UIControlState.normal)
    } else {
      stopTimer()
    }
}
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SegueEditRoutine" {
      let vc = segue.destination as! MSEViewController
      
      vc.routine = routine
    }
  }
  
  
  // MARK: UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if routine != nil {
      return routine!.excerciseSets.count
    } else {
      return 3
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellID = "XSetCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! XSetView
    if routine != nil {
      let xSet = routine!.excerciseSets[indexPath.row]
      let timeLeft = MSETableViewController.formatTime(fromSeconds: xSet.timeLeft)
      cell.xSetLabel.text = String(format: "#%i %@ %@", indexPath.row + 1, xSet.getDescription(), timeLeft)
    }
    return cell
  }
  
}
