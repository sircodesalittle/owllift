//
//  ActiveWorkoutCell.swift
//  OwlLift
//
//  Created by Alex Dykstra on 2/10/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class ActiveWorkoutCell: UITableViewCell {

    var workoutDateData: NSDate?
    @IBOutlet weak var workoutDate: UILabel!
    @IBOutlet weak var workoutDateLine2: UILabel!
    @IBOutlet weak var numExerciseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
