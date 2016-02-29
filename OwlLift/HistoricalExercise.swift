import UIKit

class HistoricalExercise: NSObject, NSCoding {
    
    // Attributes
    var name: String
    var numCompleted: [Int]
    var completed: [Int]?
    var date: NSDate
    
    struct PropertyKey {
        static let nameKey = "name"
        static let numCompletedKey = "numCompleted"
        static let dateKey = "date"
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("historicalExercises")
    
    init? (name: String, numCompleted: [Int], date: NSDate) {
        self.name = name
        self.numCompleted = numCompleted
        self.date = date
        
        super.init()
        
        if (name.isEmpty) {
            return nil
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(numCompleted, forKey: PropertyKey.numCompletedKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let numCompleted = aDecoder.decodeObjectForKey(PropertyKey.numCompletedKey) as! [Int]
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        
        // Must call designated initializer.
        self.init(name: name, numCompleted: numCompleted, date: date)
    }
    
    func customDescription() -> String {
        return name + " : " + String(numCompleted)
    }
    
    override var description: String {
        return customDescription()
    }
}
