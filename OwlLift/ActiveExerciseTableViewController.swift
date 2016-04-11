//
//  ActiveExerciseTableViewController.swift
//  OwlLift
//
//  Created by Alex Dykstra on 2/12/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class ActiveExerciseTableViewController: UITableViewController {

    var workoutExercises = [Exercise]()
    var completedExercises = [HistoricalExercise]()
    var workoutDate: NSDate?
    var workouts: [Workout]?
    var exercises: [Exercise]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        
        // Don't show empty cells at the bottom of the tableView
        //tableView.tableFooterView = UIView(frame: CGRectZero)

        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle

        navigationItem.title = formatter.stringFromDate(workoutDate!)
        
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
        return workoutExercises.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ActiveExerciseCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ActiveExerciseTableViewCell
        let exercise = workoutExercises[indexPath.row]
        
        cell.exerciseNameLabel.text = exercise.name
        cell.setRepLabel.text = String(Int(exercise.numSets)) + " x " + String(Int(exercise.numReps)) + " at " + String(Int(exercise.weight)) + " lbs"
        cell.setRepView.sets = exercise.numSets
        cell.setRepView.reps = exercise.numReps
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        if let completedAlready = loadHistoricalExercises() {
            completedExercises = completedAlready
        }
        else {
            print("No exercises completed yet")
        }
        tableView.reloadData()
    }
    
    func loadExerciseSamples() {
        let ex1 = Exercise(name: "Bench Press", numSets: 5, numReps: 5, weight: 135, autoIncrement: true)
        let ex2 = Exercise(name: "Squat", numSets: 5, numReps: 5, weight: 135, autoIncrement: true)
        
        exercises!.append(ex1!)
        exercises!.append(ex2!)
    }
    
    func printCompleted() {
        var toSave: HistoricalExercise
        
        if let loadedExercises = loadExercises() {
            exercises = loadedExercises
        }
        else {
            exercises = []
            loadExerciseSamples()
        }
        
        workouts = loadWorkouts()
        
        // If "Save and Quit" selected", save all the exercises and completed reps, then exit
        let numRows = tableView.numberOfRowsInSection(0) - 1
        for row in 0...numRows
        {
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            
            // For cells that have not been drawn yet.
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ActiveExerciseTableViewCell
            let targetReps = cell.setRepView.reps!
            
            // Find out if the target reps were met
            var success = true
            let completed = cell.setRepView.returnData()
            if completed.count == workoutExercises[indexPath.row].numSets {
                for set in completed {
                    if set != workoutExercises[indexPath.row].numReps {
                        success = false
                    }
                }
            }
            else {
                print("uh oh, for some reason completed set number does not match exercise set number.")
            }
            
            var notes = ["none"]
            
            // If all reps of all sets were completed, increment the weight on the exercise by 5 lbs.
            if success {
                for exercise in exercises! {
                    if workoutExercises[indexPath.row].name == exercise.name && exercise.autoIncrement {
                        exercise.weight += 5
                    }
                }
                saveExercises()
                // If an exercise changes, update it.
                workouts = loadWorkouts()
                for workout in workouts! {
                    for (index, workoutExercise) in workout.exercises.enumerate() {
                        for exercise in exercises! {
                            if exercise.name == workoutExercise.name {
                                workout.exercises[index] = exercise
                            }
                        }
                    }
                }
                saveWorkouts()
                notes = ["Great job! +5lbs."]
                print("weight incremented")
            }
            
            toSave = HistoricalExercise(name: cell.exerciseNameLabel.text!, numCompleted: cell.setRepView.returnData(), date: workoutDate!, numTargetReps: targetReps, notes:notes, exercise: workoutExercises[indexPath.row])!
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
    
    func saveExercises() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(exercises!, toFile: Exercise.ArchiveURL.path!)
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

}
