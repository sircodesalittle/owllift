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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        navigationItem.title = formatter.stringFromDate(historicalExercises[0].date)
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
        return historicalExercises.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "HistoricExerciseCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! HistoricExerciseTableViewCell
        
        let historicalExercise = historicalExercises[indexPath.row]
        
//        cell.setRepLabel.text = String(Int(exercise.numSets)) + " x " + String(Int(exercise.numReps)) + " at " + String(Int(exercise.weight)) + " lbs"
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
