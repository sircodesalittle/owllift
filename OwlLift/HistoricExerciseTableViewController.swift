//
//  HistoricExerciseTableViewController.swift
//  OwlLift
//
//  Created by Alex Dykstra on 3/25/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class HistoricExerciseTableViewController: UITableViewController {

    var historicalExercises = [HistoricalExercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.darkGrayColor()
        
        // Don't show empty cells at the bottom of the tableView
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Date formatter so we can display the date of what history we are viewing.
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        navigationItem.title = formatter.stringFromDate(historicalExercises[0].date)
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
        return historicalExercises.count
    }
    
    // Construct the HistoricExeciseCells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "HistoricExerciseCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! HistoricExerciseTableViewCell
        
        let historicalExercise = historicalExercises[indexPath.row]
        
        cell.repLabel.text = String(Int(historicalExercise.exercise.numSets)) + " x " + String(Int(historicalExercise.exercise.numReps)) + " at " + String(Int(historicalExercise.exercise.weight)) + " lbs"
        cell.exerciseNameLabel.text = historicalExercise.name
        cell.setRepControlBox.sets = historicalExercise.numCompleted.count
        cell.setRepControlBox.reps = historicalExercise.numTargetReps
        cell.setRepControlBox.completedReps = historicalExercise.numCompleted
        
        var exerciseNote = ""
        for note in historicalExercise.notes {
            exerciseNote += note + "\n"
        }
        
        if exerciseNote == "none\n" {
            exerciseNote = ""
        }
        cell.notesLabel.text = exerciseNote
        
        return cell
    }
}
