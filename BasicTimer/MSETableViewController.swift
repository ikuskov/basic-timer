//
//  MultiSetExcerciseTableViewController.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import UIKit

class MSETableViewController: UITableViewController {
  
  var routines = [Routine]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = editButtonItem
    
    if let savedRoutines = loadData(), savedRoutines.count > 0 {
      routines += savedRoutines
    } else {
      loadSampleData()
    }
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  // MARK: Helpers
  
  func loadSampleData() {
    let set1 = TimedSet(name: "Bench press", repsCount: 5, weight: 180, duration: 3*60)!
    var setArr1 = [TimedSet]()
    for _ in 0...4 {
      setArr1.append(set1.copy() as! TimedSet)
    }
    let excercise1 = Routine(name: "Bench press", excerciseSets: setArr1)!
    routines += [excercise1]
    
    let set2 = TimedSet(name: "Squats", repsCount: 6, weight:95, duration: 3*60)!
    var setArr2 = [TimedSet]()
    for _ in 0...3 {
      setArr2.append(set2.copy() as! TimedSet)
    }
    let excercise2 = Routine(name: "Squats", excerciseSets: setArr2)!
    routines += [excercise2]
  }
  
  static func format(time: TimeInterval) -> String {
    let fromSeconds = Int(time)
    let seconds = fromSeconds % 60
    let minutes = fromSeconds / 60 % 60
    let hours = fromSeconds / (60 * 60)
    if hours == 0 {
      return String(format: "%02i:%02i", minutes, seconds)
    } else {
      return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return routines.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellID = "MultiSetExcerciseCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MSETableViewCell
    
    let excercise = routines[indexPath.row]
    cell.name.text = excercise.name
    let timedSet = excercise.excerciseSets[0]
    cell.timeLabel.text = MSETableViewController.format(time: timedSet.duration)
    
    cell.descriptionLabel.text = excercise.getDescription()
    
    return cell
  }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
          
          routines.remove(at: indexPath.row)
          saveData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SegueEditRoutine" {
      let vc = segue.destination as! MSEViewController
      
      if let button = sender as? UIButton {
        if let superview = button.superview {
          if let selectedCell = superview.superview as? MSETableViewCell {
            let indexPath = tableView.indexPath(for: selectedCell)!
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            let routine = routines[indexPath.row]
            vc.routine = routine
          }
        }
      }
    } else if segue.identifier == "SegueShowRoutine" {
      let vc = segue.destination as! RoutineViewController
      
      if let selectedCell = sender as? MSETableViewCell {
        let indexPath = tableView.indexPath(for: selectedCell)!
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        let routine = routines[indexPath.row]
        vc.routine = routine
      }
    } else if segue.identifier == "SegueAddRoutine" {
      print("Add routine")
    }
  }
  
  @IBAction func applyNewData(sender: UIStoryboardSegue) {
    if let source = sender.source as? MSEViewController, let routine = source.routine {
      if let indexPath = tableView.indexPathForSelectedRow {
        routines[indexPath.row] = routine
        tableView.reloadRows(at: [indexPath], with: .none)
      } else {
        let newIndex = IndexPath(row: routines.count, section: 0)
        routines.append(routine)
        tableView.insertRows(at: [newIndex], with: .bottom)
      }
      
      saveData()
    }
  }
  
  // MARK: NSCoding
  
  func saveData() {
    let success = NSKeyedArchiver.archiveRootObject(routines, toFile: Routine.ArchiveURL.path)
    
    if !success {
      print("Failed to save!")
    } else {
      print("Succesfully saved!")
    }
  }
  
  func loadData() -> [Routine]? {
    let rs = NSKeyedUnarchiver.unarchiveObject(withFile: Routine.ArchiveURL.path) as? [Routine]
    print("Loaded routines!", (rs ?? []).count)
    return rs
  }
}
