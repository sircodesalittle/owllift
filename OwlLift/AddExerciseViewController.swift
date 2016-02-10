//
//  AddExerciseViewController.swift
//  OwlLift
//
//  Created by Alex Dykstra on 1/30/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseNameTextField: UITextField!

    @IBOutlet weak var setStepper: UIStepper!
    @IBOutlet weak var setLabel: UILabel!

    @IBOutlet weak var repStepper: UIStepper!
    @IBOutlet weak var repLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightStepper: UIStepper!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.enabled = false
        exerciseNameTextField.delegate = self
        
        setStepper.minimumValue = 1
        setStepper.value = 1
        setLabel.text = String(Int(setStepper.value))
        
        repStepper.minimumValue = 1
        repStepper.value = 1
        repLabel.text = String(Int(repStepper.value))
        
        weightStepper.stepValue = 5
        weightStepper.maximumValue = 500
        weightLabel.text = String(Int(weightStepper.value))
        
        if let exercise = exercise {
            navigationItem.title = exercise.name
            exerciseNameLabel.text = exercise.name
            setLabel.text = String(exercise.numSets)
            repLabel.text = String(exercise.numReps)
            weightLabel.text = String(exercise.weight)
            exerciseNameTextField.text = exercise.name
            setStepper.value = Double(exercise.numSets)
            repStepper.value = Double(exercise.numReps)
            weightStepper.value = Double(exercise.weight)
        }
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidExerciseName()
        navigationItem.title = textField.text
        exerciseNameLabel.text = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidExerciseName() {
        // Disable the Save button if the text field is empty.
        let text = exerciseNameTextField.text ?? ""
        if (!text.isEmpty) {
            saveButton.enabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setNumChanged(sender: UIStepper) {
        checkValidExerciseName()
        self.setLabel.text = String(Int(sender.value))
    }
    
    @IBAction func repNumChanged(sender: UIStepper) {
        checkValidExerciseName()
        self.repLabel.text = String(Int(sender.value))
    }

    @IBAction func weightChanged(sender: UIStepper) {
        checkValidExerciseName()
        self.weightLabel.text = String(Int(sender.value))
    }
    
    // MARK: - Navigation
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = exerciseNameTextField.text ?? ""
            let setNum = Int(setLabel.text!)
            let repNum = Int(repLabel.text!)
            let weight = Int(weightLabel.text!)
            
            // Set the meal to be passed to MealListTableViewController after the unwind segue.
            exercise = Exercise(name: name, numSets: setNum!, numReps: repNum!, weight: weight!)
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddExerciseMode = presentingViewController is UINavigationController
        
        if isPresentingInAddExerciseMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
