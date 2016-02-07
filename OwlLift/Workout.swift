//
//  Workout.swift
//  OwlLift
//
//  Created by Alex Dykstra on 1/29/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class Workout: NSObject, NSCoding {
    
    // Attributes
    var name: String
    var exercises: [Exercise]
    var complete: Bool
    var activated: Bool
    
    struct PropertyKey {
        static let workoutNameKey = "name"
        static let exercisesKey = "exercises"
        static let completeKey = "complete"
        static let activatedKey = "activated"
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("workouts")
    
    init? (name: String, exercises: [Exercise], complete: Bool, activated: Bool) {
        self.name = name
        self.exercises = exercises
        self.complete = complete
        self.activated = activated
        
        super.init()
        
        if (name.isEmpty) {
            return nil
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.workoutNameKey)
        aCoder.encodeObject(exercises, forKey: PropertyKey.exercisesKey)
        aCoder.encodeObject(complete, forKey: PropertyKey.completeKey)
        aCoder.encodeObject(activated, forKey: PropertyKey.activatedKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.workoutNameKey) as! String
        let exercises = aDecoder.decodeObjectForKey(PropertyKey.exercisesKey) as! [Exercise]
        let complete = aDecoder.decodeObjectForKey(PropertyKey.completeKey) as! Bool
        let activated = aDecoder.decodeObjectForKey(PropertyKey.activatedKey) as! Bool
        
        self.init(name: name, exercises: exercises, complete: complete, activated: activated)
    }
}
