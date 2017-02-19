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
  
  @IBOutlet weak var nameField: UILabel!
  @IBOutlet weak var setsTable: UITableView!
  
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
    // create a sound ID, in this case its the tweet sound.
    let systemSoundID = 1016
    
    // to play sound
    AudioServicesPlaySystemSound(SystemSoundID(systemSoundID))
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
      cell.xSetLabel.text = String(format: "#%i %@", indexPath.row + 1, xSet.getDescription())
    }
    return cell
  }
  
}