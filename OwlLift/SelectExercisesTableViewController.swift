import UIKit

class SelectExercisesTableViewController: UITableViewController {
    
    // MARK: Properties
    var workoutName = String()
    var exercises = [Exercise]()
    var selectedExercises: [Exercise]?
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
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
            loadExerciseSamples()
        }
        
        navigationItem.title = workoutName
    }
    
    func loadExerciseSamples() {
        let ex1 = Exercise(name: "Bench Press", numSets: 5, numReps: 5, weight: 135, autoIncrement: true)
        let ex2 = Exercise(name: "Squat", numSets: 5, numReps: 5, weight: 135, autoIncrement: true)
        
        exercises.append(ex1!)
        exercises.append(ex2!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.darkGrayColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ExerciseCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ExerciseTableViewCell
        
        let exercise = exercises[indexPath.row]
        cell.tintColor = UIColor.lightGrayColor()
        cell.exerciseNameLabel.text = exercise.name
        cell.setLabel.text = String(Int(exercise.numSets))
        cell.repLabel.text = String(Int(exercise.numReps))
        cell.weightLabel.text = String(Int(exercise.weight)) + " lbs"
        for selectedEx in selectedExercises! {
            if selectedEx.name == exercise.name {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if doneButton === sender {
            // Do nothing for now.... TODO
        }
    }
    
    func loadExercises() -> [Exercise]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Exercise.ArchiveURL.path!) as? [Exercise]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var needToAdd = true
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ExerciseTableViewCell
        for (index, selectedEx) in selectedExercises!.enumerate() {
            if exercises[indexPath.row].name == selectedEx.name {
                // Workout already in array, remove the exercise from array.
                selectedExercises!.removeAtIndex(index)
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.reloadInputViews()
                needToAdd = false
            }
        }
        if needToAdd {
            selectedExercises?.append(exercises[indexPath.row])
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    }
    
    /*
        // Override to support editing the table view.
        override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .Delete {
    //            // Delete the row from the data source
    //            exercises.removeAtIndex(indexPath.row)
    //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            } else if editingStyle == .Insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
    */

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
