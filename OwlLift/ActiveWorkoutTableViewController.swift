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
        
        if let savedWorkouts = loadWorkouts() {
            workouts += savedWorkouts
        } else {
            loadDefaultWorkouts()
        }
        
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
        cell.workoutDateLine2.text = cellDate.formattedFromCompenents(NSDateFormatterStyle.LongStyle, year: false, month: true, day: true, hour: false, minute: false, second: false)
        
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
