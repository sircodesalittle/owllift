//
//  Exercise.swift
//  OwlLift
//
//  Created by Alex Dykstra on 1/29/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class Exercise: NSObject, NSCoding {
    
    // Attributes
    var name: String
    var numSets: Int
    var numReps: Int
    var weight: Int
    
    struct PropertyKey {
        static let exerciseNameKey = "name"
        static let numSetKey = "sets"
        static let numRepKey = "reps"
        static let weightKey = "weight"
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("exercises")
    
    init? (name: String, numSets: Int, numReps: Int, weight: Int) {
        self.name = name
        self.numSets = numSets
        self.numReps = numReps
        self.weight = weight
        
        super.init()
        
        if (name.isEmpty) {
            return nil
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.exerciseNameKey)
        aCoder.encodeObject(numSets, forKey: PropertyKey.numSetKey)
        aCoder.encodeInteger(numReps, forKey: PropertyKey.numRepKey)
        aCoder.encodeInteger(weight, forKey: PropertyKey.weightKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.exerciseNameKey) as! String
        
        let numSets = aDecoder.decodeObjectForKey(PropertyKey.numSetKey) as! Int
        
        let numReps = aDecoder.decodeIntegerForKey(PropertyKey.numRepKey)
        
        let weight = aDecoder.decodeIntegerForKey(PropertyKey.weightKey)
        
        // Must call designated initializer.
        self.init(name: name, numSets: numSets, numReps: numReps, weight: weight)
    }
}
