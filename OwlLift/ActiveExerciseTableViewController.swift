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
    var workout: Workout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        
        // Don't show empty cells at the bottom of the tableView
        tableView.tableFooterView = UIView(frame: CGRectZero)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        if let completedAlready = loadHistoricalExercises() {
            completedExercises = completedAlready
        }
        else {
            print("No exercises completed yet")
        }
        tableView.reloadData()
    }
    
    func printCompleted() {
        var toSave: HistoricalExercise
        
        // If "Save and Quit" selected", save all the exercises and completed reps, then exit
        for row in 0...tableView.numberOfRowsInSection(0) - 1
        {
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ActiveExerciseTableViewCell
            let targetReps = cell.setRepView.reps!
            toSave = HistoricalExercise(name: cell.exerciseNameLabel.text!, numCompleted: cell.setRepView.returnData(), date: workoutDate!, numTargetReps: targetReps, notes:["none"], exercise: exercises[indexPath.row])!
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
}
