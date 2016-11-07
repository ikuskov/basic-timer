//
//  ViewController.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import UIKit

class MSEViewController: UIViewController {
  
  var routine: Routine?

  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var weightField: UITextField!
  @IBOutlet weak var repsField: UITextField!
  @IBOutlet weak var setsField: UITextField!
  @IBOutlet weak var timePicker: BlockyTimePicker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    if let routine = routine {
      nameField.text = routine.name
      let timedSet = routine.excerciseSets[0]
      weightField.text = String(timedSet.weight!)
      repsField.text = String(timedSet.repsCount!)
      setsField.text = String(routine.excerciseSets.count)
      timePicker.duration = timedSet.duration
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if saveButton === sender as? UIBarButtonItem {
      let name = nameField.text
      let weight = Int(weightField.text ?? "0")
      let repsCount = Int(repsField.text ?? "0")
      let setsCount = Int(setsField.text ?? "1")
      let duration = timePicker.duration
      
      let timedSet = TimedSet(name: name ?? "Set", repsCount: repsCount, weight: weight, duration: duration)
      let tsArray = Array(repeating: timedSet!, count: setsCount!)
      
      routine = Routine(name: name ?? "MSE", excerciseSets: tsArray)
    }
  }
}

