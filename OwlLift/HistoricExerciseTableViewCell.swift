//
//  HistoricExerciseTableViewCell.swift
//  OwlLift
//
//  Created by Alex Dykstra on 3/25/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class HistoricExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    @IBOutlet weak var setRepControlBox: setRepControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
