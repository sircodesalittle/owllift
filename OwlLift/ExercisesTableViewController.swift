//
//  ExercisesTableViewController.swift
//  OwlLift
//
//  Created by Alex Dykstra on 1/29/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class ExercisesTableViewController: UITableViewController {

    // MARK: Properties
    var exercises = [Exercise]()
    var workouts: [Workout]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.darkGrayColor()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let savedExercises = loadExercises() {
            exercises += savedExercises
        } else {
            // Load the sample data.
            loadExerciseSamples()
        }
    }
    
    func loadExerciseSamples() {
        let ex1 = Exercise(name: "Bench Press", numSets: 5, numReps: 5, weight: 135)
        let ex2 = Exercise(name: "Squat", numSets: 5, numReps: 5, weight: 135)
        
        exercises.append(ex1!)
        exercises.append(ex2!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.darkGrayColor()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ExerciseCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ExerciseTableViewCell

        let exercise = exercises[indexPath.row]
        cell.exerciseNameLabel.text = exercise.name
        cell.setLabel.text = String(Int(exercise.numSets))
        cell.repLabel.text = String(Int(exercise.numReps))
        cell.weightLabel.text = String(Int(exercise.weight)) + " lbs"
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            exercises.removeAtIndex(indexPath.row)
            saveExercises()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let exerciseDetailViewController = segue.destinationViewController as! AddExerciseViewController
            
            // Get the cell that generated this segue.
            if let selectedExerciseCell = sender as? ExerciseTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedExerciseCell)!
                let selectedExercise = exercises[indexPath.row]
                exerciseDetailViewController.exercise = selectedExercise            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new exercise.")
        }
    }

    
    @IBAction func unwindToExerciseList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddExerciseViewController, exercise = sourceViewController.exercise {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                exercises[selectedIndexPath.row] = exercise
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                let newIndexPath = NSIndexPath(forRow: exercises.count, inSection: 0)
                exercises.append(exercise)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            saveExercises()
            
            // If an exercise changes, update it.
            workouts = loadWorkouts()
            for workout in workouts! {
                for (index, workoutExercise) in workout.exercises.enumerate() {
                    for exercise in exercises {
                        if exercise.name == workoutExercise.name {
                            workout.exercises[index] = exercise
                        }
                    }
                }
            }
            saveWorkouts()
        }
    }
    
    func saveExercises() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(exercises, toFile: Exercise.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save exercises...")
        }
    }
    
    func loadExercises() -> [Exercise]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Exercise.ArchiveURL.path!) as? [Exercise]
    }

    func saveWorkouts() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(workouts!, toFile: Workout.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save workouts...")
        }
    }
    
    func loadWorkouts() -> [Workout]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Workout.ArchiveURL.path!) as? [Workout]
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
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
}
