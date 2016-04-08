//
//  ChartExerciseTableViewController.swift
//  OwlLift
//
//  Created by Alex Dykstra on 4/5/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class ChartExerciseTableViewController: UITableViewController {

    var completedExercises = [HistoricalExercise]()
    var exerciseDict = [String:[HistoricalExercise]]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        
        // Don't show empty cells at the bottom of the tableView
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        navigationItem.title = "Charts"
    }

    override func viewWillAppear(animated: Bool) {
        if let loadedExercises = loadHistoricalExercises() {
            completedExercises = loadedExercises
            compileExercises()
        }
        else {
            print("No historical data.")
        }
        tableView.reloadData()
    }
    
    // In order to update the list of completed exercises.
    // Could be refactored to be more efficient, but at this point it has little overhead.
    override func viewWillDisappear(animated: Bool) {
        exerciseDict.removeAll(keepCapacity: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if completedExercises.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            emptyLabel.text = "No Exercises Completed"
            emptyLabel.textAlignment = NSTextAlignment.Center
            emptyLabel.textColor = UIColor.whiteColor()
            
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            tableView.backgroundView = nil
        }
        return exerciseDict.keys.count
    }

    func loadHistoricalExercises() -> [HistoricalExercise]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(HistoricalExercise.ArchiveURL.path!) as? [HistoricalExercise]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "ChartCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ChartExerciseTableViewCell
        
        let dictKey = Array(exerciseDict.keys.sort())[indexPath.row]
        let exercises = exerciseDict[dictKey]
        
        //let completedExercise = completedExercises[indexPath.row]
        cell.exerciseNameLabel.text = exercises![0].name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    func compileExercises() {
        for exercise in completedExercises {
            let containsKey = exerciseDict[exercise.name] != nil
            
            if !containsKey {
                exerciseDict[exercise.name] = []
                exerciseDict[exercise.name]!.append(exercise)
            }
            else {
                var exerciseDates = [NSDate]()
                for exercisesInDict in exerciseDict[exercise.name]! {
                    exerciseDates.append(exercisesInDict.date)
                }
                if !exerciseDates.contains(exercise.date) {
                    exerciseDict[exercise.name]!.append(exercise)
                }
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CellToChart" {
            let exerciseChart = segue.destinationViewController as! ExerciseChartViewController
            
            // Get the cell that generated this segue.
            if let selectedExerciseCell = sender as? ChartExerciseTableViewCell {
                //let indexPath = tableView.indexPathForCell(selectedWorkoutCell)!
                let selectedHistoricalExercise = exerciseDict[selectedExerciseCell.exerciseNameLabel.text!]
                //let selectedWorkout = completedWorkouts[indexPath.row]
                exerciseChart.exerciseArray = selectedHistoricalExercise!
            }
        }
    }
 

}
