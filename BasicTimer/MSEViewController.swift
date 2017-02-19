//
//  ViewController.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import UIKit

class MSEViewController: UIViewController, BlockyTimePickerDelegate {
  
  var routine: Routine?

  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var weightField: UITextField!
  @IBOutlet weak var repsField: UITextField!
  @IBOutlet weak var setsField: UITextField!
  @IBOutlet weak var timePicker: BlockyTimePicker!
  @IBOutlet weak var minutesField: UITextField!
  @IBOutlet weak var secondsField: UITextField!
  @IBOutlet weak var repsStepper: UIStepper!
  @IBOutlet weak var setsStepper: UIStepper!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    timePicker.delegate = self
    
    if let routine = routine {
      nameField.text = routine.name
      let timedSet = routine.excerciseSets[0]
      print(routine.getGroups())
      weightField.text = String(timedSet.weight)
      repsField.text = String(timedSet.repsCount)
      setsField.text = String(routine.excerciseSets.count)
      timePicker.duration = timedSet.duration
      repsStepper.value = Double(timedSet.repsCount)
      setsStepper.value = Double(routine.excerciseSets.count)
    }
    
    // To hide keyboard on taps outside of text edit area
    view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view.endEditing)))
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
      let setsCount = Int(setsField.text ?? "1") ?? 1
      let duration = timePicker.duration
      
      let timedSet = TimedSet(name: name ?? "Set", repsCount: repsCount, weight: weight ?? 0, duration: duration)!
      var tsArray = [TimedSet]()
      for _ in 1...setsCount {
        tsArray.append(timedSet.copy() as! TimedSet)
      }
//      setArr1.append(set1.copy() as! TimedSet)
//      let tsArray = Array(repeating: timedSet!, count: setsCount ?? 1)
      
      routine = Routine(name: name ?? "MSE", excerciseSets: tsArray)
    }
  }
  
  // MARK: BlockyTimePickerDelegate
  
  func durationDidUpdate(_ duration: Int) {
    minutesField.text = String(format: "%02i", duration / 60 % 60)
    secondsField.text = String(format: "%02i", duration % 60)
  }
  
  // MARK: Steppers
  
  @IBAction func repsValueChanged(_ sender: UIStepper) {
    repsField.text = String(Int(sender.value))
  }
  @IBAction func setsValueChanged(_ sender: UIStepper) {
    setsField.text = String(Int(sender.value))
  }
}

