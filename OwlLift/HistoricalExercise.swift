import UIKit

class HistoricalExercise: NSObject, NSCoding {
    
    // Attributes
    var name: String
    var numCompleted: [Int]
    var completed: [Int]?
    var date: NSDate
    var numTargetReps: Int
    var notes: [String]
    
    struct PropertyKey {
        static let nameKey = "name"
        static let numCompletedKey = "numCompleted"
        static let dateKey = "date"
        static let numTargetReps = "numTargetReps"
        static let notes = "notes"
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("historicalExercises")
    
    init? (name: String, numCompleted: [Int], date: NSDate, numTargetReps: Int, notes: [String]) {
        self.name = name
        self.numCompleted = numCompleted
        self.date = date
        self.numTargetReps = numTargetReps
        self.notes = notes
        
        super.init()
        
        if (name.isEmpty) {
            return nil
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(numCompleted, forKey: PropertyKey.numCompletedKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(numTargetReps, forKey: PropertyKey.numTargetReps)
        aCoder.encodeObject(notes, forKey: PropertyKey.notes)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let numCompleted = aDecoder.decodeObjectForKey(PropertyKey.numCompletedKey) as! [Int]
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        let numTargetReps = aDecoder.decodeObjectForKey(PropertyKey.numTargetReps) as! Int
        let notes = aDecoder.decodeObjectForKey(PropertyKey.notes) as! [String]
        // Must call designated initializer.
        self.init(name: name, numCompleted: numCompleted, date: date, numTargetReps: numTargetReps, notes: notes)
    }
    
    func customDescription() -> String {
        return name + " : " + String(numCompleted)
    }
    
    override var description: String {
        return customDescription()
    }
}
