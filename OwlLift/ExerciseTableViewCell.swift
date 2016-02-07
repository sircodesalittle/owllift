//
//  ExerciseTableViewCell.swift
//  OwlLift
//
//  Created by Alex Dykstra on 1/30/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
