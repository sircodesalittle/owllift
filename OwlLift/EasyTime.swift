// Credits to GeneratorOfOne on StackOverflow

import UIKit

let dateFormatter = NSDateFormatter()
//dateFormatter.locale = NSLocale.currentLocale()
//dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
//let x = dateFormatter.stringFromDate(date)

func getWeekDaysInEnglish() -> [String] {
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return calendar.weekdaySymbols
}

enum SearchDirection {
    case Next
    case Previous
    
    var calendarOptions: NSCalendarOptions {
        switch self {
        case .Next:
            return .MatchNextTime
        case .Previous:
            return [.SearchBackwards, .MatchNextTime]
        }
    }
}

func get(direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> NSDate {
    let weekdaysName = getWeekDaysInEnglish()
    
    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
    
    let nextWeekDayIndex = weekdaysName.indexOf(dayName)! + 1 // weekday is in form 1 ... 7 where as index is 0 ... 6
    
    let today = NSDate()
    
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    if consider && calendar.component(.Weekday, fromDate: today) == nextWeekDayIndex {
        return today
    }
    
    let nextDateComponent = NSDateComponents()
    nextDateComponent.weekday = nextWeekDayIndex
    
    
    let date = calendar.nextDateAfterDate(today, matchingComponents: nextDateComponent, options: direction.calendarOptions)
    return date!
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    func formattedFromCompenents(styleAttitude: NSDateFormatterStyle, year: Bool = true, month: Bool = true, day: Bool = true, hour: Bool = true, minute: Bool = true, second: Bool = true) -> String {
        let long = styleAttitude == .LongStyle || styleAttitude == .FullStyle ? true : false
        var comps = ""
        
        if year { comps += long ? "yyyy" : "yy" }
        if month { comps += long ? "MMMM" : "MMM" }
        if day { comps += long ? "dd" : "d" }
        
        if hour { comps += long ? "HH" : "H" }
        if minute { comps += long ? "mm" : "m" }
        if second { comps += long ? "ss" : "s" }
        
        let format = NSDateFormatter.dateFormatFromTemplate(comps, options: 0, locale: NSLocale.currentLocale())
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
}
