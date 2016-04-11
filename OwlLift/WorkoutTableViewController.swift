//
//  WorkoutTableViewController.swift
//  OwlLift
//
//  Created by Alex Dykstra on 2/6/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class WorkoutTableViewController: UITableViewController {

    // MARK: Properties
    var workouts = [Workout]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.darkGrayColor()
        
        workouts = loadWorkouts()!
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
        return workouts.count
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.darkGrayColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "WorkoutTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTableViewCell
        
        let workout = workouts[indexPath.row]
        
        cell.nameLabel.text = workout.name
        cell.activated.on = workout.activated
        cell.numExercises.text = String(workout.exercises.count) + " Exercises"

        return cell
    }
    
    @IBAction func switchChanged(sender: UISwitch) {
        let senderCell = sender.superview?.superview?.superview as! WorkoutTableViewCell
        let indexPath = tableView.indexPathForCell(senderCell)!
        let selectedWorkout = workouts[indexPath.row]
        selectedWorkout.activated = sender.on
        saveWorkouts()
        tableView.reloadData()
    }

    func saveWorkouts() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(workouts, toFile: Workout.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save workouts...")
        }
    }
    
    func loadWorkouts() -> [Workout]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Workout.ArchiveURL.path!) as? [Workout]
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectExercises" {
            let workoutDetailViewController = segue.destinationViewController as! SelectExercisesTableViewController

            // Get the cell that generated this segue.
            if let selectedWorkoutCell = sender as? WorkoutTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedWorkoutCell)!
                let selectedWorkout = workouts[indexPath.row]
                workoutDetailViewController.selectedExercises = selectedWorkout.exercises
                workoutDetailViewController.workoutName = selectedWorkout.name
            }
        }
    }
    
    @IBAction func unwindToWorkoutList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? SelectExercisesTableViewController {
            if let selectedWorkout = tableView.indexPathForSelectedRow {
                workouts[selectedWorkout.row].exercises = sourceViewController.selectedExercises!
                tableView.reloadRowsAtIndexPaths([tableView.indexPathForSelectedRow!], withRowAnimation: .None)
            }
            saveWorkouts()
            
        }
    }
}
