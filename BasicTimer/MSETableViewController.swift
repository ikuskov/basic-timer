//
//  MultiSetExcerciseTableViewController.swift
//  BasicTimer
//
//  Created by Ivan Kuskov on 11/6/16.
//  Copyright © 2016 Ivan Kuskov. All rights reserved.
//

import UIKit

class MSETableViewController: UITableViewController {
  
  var routines = [MultiSetExcercise]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadSampleData()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  // MARK: Helpers
  
  func loadSampleData() {
    let set1 = TimedSet(name: "Bench press", repsCount: 5, weight: 180, duration: 3*60)!
    let setArr1 = Array(repeating: set1, count: 4)
    let excercise1 = MultiSetExcercise(name: "Bench press", excerciseSets: setArr1)!
    routines += [excercise1]
    
    let set2 = TimedSet(name: "Squats", repsCount: 6, weight:95, duration: 3*60)!
    let setArr2 = Array(repeating: set2, count: 3)
    let excercise2 = MultiSetExcercise(name: "Squats", excerciseSets: setArr2)!
    routines += [excercise2]
  }
  
  func formatTime(fromSeconds: Int) -> String {
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
    if let timedSet = excercise.excerciseSets?[0] {
      cell.timeLabel.text = formatTime(fromSeconds: timedSet.duration)
    } else {
      cell.timeLabel.text = "--:--"
    }
    
    cell.descriptionLabel.text = excercise.getDescription()
    
    return cell
  }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
      
      if let selectedCell = sender as? MSETableViewCell {
        let indexPath = tableView.indexPath(for: selectedCell)!
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
        print(indexPath)
      } else {
        let newIndex = IndexPath(row: routines.count, section: 0)
        routines.append(routine)
        tableView.insertRows(at: [newIndex], with: .bottom)
      }
    }
  }

}
