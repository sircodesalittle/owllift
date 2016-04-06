//
//  ActiveWorkoutTableViewController.swift
//  OwlLift
//
//  Created by Alex Dykstra on 2/10/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class ActiveWorkoutTableViewController: UITableViewController {

    // MARK: Properties
    var workouts = [Workout]()
    let currentDate = NSDate()
    let thisWeeksMonday = get(.Previous, "Monday", considerToday: true)
    let dateFormatter = NSDateFormatter()
    
    var activatedWorkouts = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        
        if let savedWorkouts = loadWorkouts() {
            workouts += savedWorkouts
        } else {
            loadDefaultWorkouts()
        }
        
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.darkGrayColor()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activatedWorkouts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ActiveWorkoutCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ActiveWorkoutCell
        let workout = activatedWorkouts[indexPath.row]
        let cellDate: NSDate
        cell.workoutDate.text = workout.name
        cell.numExerciseLabel.text = String(workout.exercises.count) + " Exercises"
        switch workout.name {
        case "Monday":
            cellDate = thisWeeksMonday
        case "Tuesday":
            cellDate = thisWeeksMonday.addDays(1)
        case "Wednesday":
            cellDate = thisWeeksMonday.addDays(2)
        case "Thursday":
            cellDate = thisWeeksMonday.addDays(3)
        case "Friday":
            cellDate = thisWeeksMonday.addDays(4)
        default:
            cellDate = NSDate()
            print("Date not found")
            
        }
        cell.workoutDateData = cellDate
        cell.workoutDateLine2.text = cellDate.formattedFromCompenents(NSDateFormatterStyle.LongStyle, year: false, month: true, day: true, hour: false, minute: false, second: false)
        cell.workoutDateLine2.textColor = UIColor.whiteColor()
        
        return cell
    }

    override func viewWillAppear(animated: Bool) {
        workouts.removeAll()
        workouts = loadWorkouts()!
        activatedWorkouts.removeAll()
        for wo in workouts {
            if !activatedWorkouts.contains(wo) && wo.activated {
                activatedWorkouts.append(wo)
            }
        }
        tableView.reloadData()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func loadDefaultWorkouts() {
        let mondayExercises = [Exercise]()
        let monday = Workout(name: "Monday", exercises: mondayExercises, complete: false, activated: true)!
        
        let tuesdayExercises = [Exercise]()
        let tuesday = Workout(name: "Tuesday", exercises: tuesdayExercises, complete: false, activated: true)!
        
        let wednesdayExercises = [Exercise]()
        let wednesday = Workout(name: "Wednesday", exercises: wednesdayExercises, complete: false, activated: true)!
        
        let thursdayExercises = [Exercise]()
        let thursday = Workout(name: "Thursday", exercises: thursdayExercises, complete: false, activated: true)!
        
        let fridayExercises = [Exercise]()
        let friday = Workout(name: "Friday", exercises: fridayExercises, complete: false, activated: false)!
        
        workouts += [monday, tuesday, wednesday, thursday, friday]
        saveWorkouts()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToActiveExercises" {
            let workoutDetailViewController = segue.destinationViewController as! ActiveExerciseTableViewController
            
            // Get the cell that generated this segue.
            if let selectedWorkoutCell = sender as? ActiveWorkoutCell {
                let indexPath = tableView.indexPathForCell(selectedWorkoutCell)!
                let selectedWorkout = workouts[indexPath.row]
                workoutDetailViewController.exercises = selectedWorkout.exercises
                workoutDetailViewController.workoutDate = selectedWorkoutCell.workoutDateData
                workoutDetailViewController.workout = selectedWorkout
            }
        }
    }
    
    @IBAction func unwindToActiveWorkoutList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ActiveExerciseTableViewController {
            sourceViewController.printCompleted()
        }
    }
}
