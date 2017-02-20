//
//  RoutineViewController.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 2/19/17.
//  Copyright © 2017 Ivan Kuskov. All rights reserved.
//

import UIKit
import AVFoundation

class RoutineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExtremeEngineDelegate {
  
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
    
    ExtremeEngine.getInstance().delegate = self
    ExtremeEngine.getInstance().select(routine: routine!)
    stateHasUpdated()
    
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
  
  @IBAction func handleStart(_ sender: Any) {
    // playSound()
    print("Called handle start")
    ExtremeEngine.getInstance().toggleTimer()
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
  
  // MARK: ExtremeEngineDelegate
  
  func stateHasUpdated() {
    if ExtremeEngine.getInstance().isRunning {
      startStopButton.setTitle("Stop it!!!1", for: UIControlState.normal)
    } else {
      startStopButton.setTitle("Let's roll!", for: UIControlState.normal)
    }
    let setInProgress = ExtremeEngine.getInstance().setInProgress!
    timeLabel.text = MSETableViewController.formatTime(fromSeconds: setInProgress.timeLeft)
    setsTable.reloadData()
  }
  
}
