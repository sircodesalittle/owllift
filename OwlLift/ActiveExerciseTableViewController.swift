//
//  ActiveExerciseTableViewController.swift
//  OwlLift
//
//  Created by Alex Dykstra on 2/12/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class ActiveExerciseTableViewController: UITableViewController {

    var exercises = [Exercise]()
    var completedExercises = [HistoricalExercise]()
    var workoutDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ActiveExerciseCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ActiveExerciseTableViewCell
        let exercise = exercises[indexPath.row]
        
        cell.exerciseNameLabel.text = exercise.name
        cell.setRepLabel.text = String(Int(exercise.numSets)) + " x " + String(Int(exercise.numReps)) + " at " + String(Int(exercise.weight)) + " lbs"
        cell.setRepView.sets = exercise.numSets
        cell.setRepView.reps = exercise.numReps
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    //TODO: Fix "Save and Quit" prompt - need to exit to default exercises screen
    @IBAction func printCompleted(sender: AnyObject) {
        var toSave: HistoricalExercise
        var exit = false

        // UIAlertController configuration
        let alertView = UIAlertController(title: "Workout Complete", message: nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save and Quit", style: .Default) { (action) in  exit = true }
        alertView.addAction(cancelAction)
        alertView.addAction(saveAction)
        presentViewController(alertView, animated: true, completion: nil)
        
        // If "Save and Quit" selected", save all the exercises and completed reps, then exit
        
        for (var row = 0; row < tableView.numberOfRowsInSection(0); row++) {
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ActiveExerciseTableViewCell
            toSave = HistoricalExercise(name: cell.exerciseNameLabel.text!, numCompleted: cell.setRepView.returnData(), date: workoutDate!)!
            completedExercises.append(toSave)
        }
        saveHistoricalExercises()
    }
    
    func saveHistoricalExercises() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(completedExercises, toFile: HistoricalExercise.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save exercises...")
        }
    }
    
    func loadHistoricalExercises() -> [HistoricalExercise]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(HistoricalExercise.ArchiveURL.path!) as? [HistoricalExercise]
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
