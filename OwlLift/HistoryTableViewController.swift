//
//  HistoryTableViewController.swift
//  OwlLift
//
//  Created by Alex Dykstra on 2/29/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    
    var completedExercises = [HistoricalExercise]()
    var completedWorkouts = [String:[HistoricalExercise]]()
    var selectedRowIndex: NSIndexPath?
    var numExercisesAtSelectedCell: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        
        // Don't show empty cells at the bottom of the tableView
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.darkGrayColor()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedWorkouts.count
    }
    
    func loadHistoricalExercises() -> [HistoricalExercise]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(HistoricalExercise.ArchiveURL.path!) as? [HistoricalExercise]
    }
    
    func saveHistoricalExercises() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(completedExercises, toFile: HistoricalExercise.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save exercises...")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "HistoricWorkoutCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! HistoryTableViewCell
        
        let dictKey = Array(completedWorkouts.keys)[indexPath.row]
        let exercises = completedWorkouts[dictKey]
        
        cell.dateLabel.text = dictKey
        cell.numExercises.text = String(exercises!.count) + " Exercises"
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        selectedRowIndex = indexPath
//        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! HistoryTableViewCell
//        
//        tableView.beginUpdates()
//        tableView.endUpdates()
//    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.row == selectedRowIndex?.row {
//            return 150
//        }
//        return 61
//    }
    
    override func viewWillAppear(animated: Bool) {
        if let loadedExercises = loadHistoricalExercises() {
            completedExercises = loadedExercises
            compileWorkouts()
            tableView.reloadData()
        }
        else {
            print("No historical data.")
        }
    }

    func compileWorkouts() {
        // The date will be the key in medium style
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        // Iterate through the completed exercise, add dict entry
        for exercise in completedExercises {
            let dateKey = formatter.stringFromDate(exercise.date)
            
            // Check if the dict already contains the dateKey
            let containsKey = completedWorkouts[dateKey] != nil
            // If it doesnt contain the key, add the array, then append
            if !containsKey {
                completedWorkouts[dateKey] = []
                completedWorkouts[dateKey]!.append(exercise)
            }
            else { // Else we just have to add the exercise entry
                // Check to make sure we don't add duplicate exercises
                var exerciseNames = [String]()
                for exerciseName in completedWorkouts[dateKey]! {
                    exerciseNames.append(exerciseName.name)
                }
                if !exerciseNames.contains(exercise.name) {
                    completedWorkouts[dateKey]!.append(exercise)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToHistoricExercises" {
            let workoutDetailViewController = segue.destinationViewController as! HistoricExerciseTableViewController
            
            // Get the cell that generated this segue.
            if let selectedWorkoutCell = sender as? HistoryTableViewCell {
                //let indexPath = tableView.indexPathForCell(selectedWorkoutCell)!
                let selectedHistoricalWorkout = completedWorkouts[selectedWorkoutCell.dateLabel.text!]
                //let selectedWorkout = completedWorkouts[indexPath.row]
                workoutDetailViewController.historicalExercises = selectedHistoricalWorkout!
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
