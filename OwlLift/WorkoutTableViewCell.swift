//
//  workoutTableViewCell.swift
//  OwlLift
//
//  Created by Alex Dykstra on 2/6/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activated: UISwitch!
    
    // DEBUG
    @IBOutlet weak var numExercises: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
