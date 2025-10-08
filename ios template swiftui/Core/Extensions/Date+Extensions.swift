import Foundation

extension Date {
    // MARK: - Date Components
    var calendar: Calendar { Calendar.current }
    
    var year: Int { calendar.component(.year, from: self) }
    var month: Int { calendar.component(.month, from: self) }
    var day: Int { calendar.component(.day, from: self) }
    var hour: Int { calendar.component(.hour, from: self) }
    var minute: Int { calendar.component(.minute, from: self) }
    var second: Int { calendar.component(.second, from: self) }
    
    // MARK: - Common Date Formats
//    enum DateFormat: String {
//        case iso8601 = "yyyy-MM-dd'T'HH:mm:ssZ"
//        case shortDate = "dd/MM/yy"
//        case mediumDate = "dd MMM yyyy"
//        case longDate = "EEEE, MMM d, yyyy"
//        case time = "HH:mm"
//        case timeWithSeconds = "HH:mm:ss"
//        case dateTime = "dd/MM/yyyy HH:mm"
//        case custom(String)
//        
//        var formatString: String {
//            switch self {
//            case .custom(let format):
//                return format
//            default:
//                return rawValue
//            }
//        }
//    }
    
    // MARK: - Formatting
//    func toString(_ format: DateFormat = .mediumDate, timezone: TimeZone = .current, locale: Locale = .current) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = format.formatString
//        formatter.timeZone = timezone
//        formatter.locale = locale
//        return formatter.string(from: self)
//    }
    
    // MARK: - Date Manipulation
    func adding(_ value: Int, _ component: Calendar.Component) -> Date {
        calendar.date(byAdding: component, value: value, to: self) ?? self
    }
    
    func subtracting(_ value: Int, _ component: Calendar.Component) -> Date {
        adding(-value, component)
    }
    
    // Common manipulations
    func addingDays(_ days: Int) -> Date { adding(days, .day) }
    func addingMonths(_ months: Int) -> Date { adding(months, .month) }
    func addingYears(_ years: Int) -> Date { adding(years, .year) }
    func addingHours(_ hours: Int) -> Date { adding(hours, .hour) }
    func addingMinutes(_ minutes: Int) -> Date { adding(minutes, .minute) }
    
    // MARK: - Date Comparisons
    func isSameDay(as date: Date) -> Bool {
        calendar.isDate(self, inSameDayAs: date)
    }
    
    var isToday: Bool {
        calendar.isDateInToday(self)
    }
    
    var isYesterday: Bool {
        calendar.isDateInYesterday(self)
    }
    
    var isTomorrow: Bool {
        calendar.isDateInTomorrow(self)
    }
    
    var isPast: Bool {
        self < Date()
    }
    
    var isFuture: Bool {
        self > Date()
    }
    
    // MARK: - Time Intervals
    var startOfDay: Date {
        calendar.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        let components = DateComponents(day: 1, second: -1)
        return calendar.date(byAdding: components, to: startOfDay) ?? self
    }
    
    var startOfMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    var endOfMonth: Date {
        let components = DateComponents(month: 1, day: -1)
        return calendar.date(byAdding: components, to: startOfMonth) ?? self
    }
    
    // MARK: - Time Ago
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    var shortTimeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    // MARK: - Date Differences
    func years(from date: Date) -> Int {
        calendar.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    func months(from date: Date) -> Int {
        calendar.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    func days(from date: Date) -> Int {
        calendar.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func hours(from date: Date) -> Int {
        calendar.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutes(from date: Date) -> Int {
        calendar.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    // MARK: - Date Creation
    static func date(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        let components = DateComponents(year: year,
                                     month: month,
                                     day: day,
                                     hour: hour,
                                     minute: minute,
                                     second: second)
        return Calendar.current.date(from: components)
    }
    
    // MARK: - Date Range
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}

// MARK: - String to Date
//extension String {
//    func toDate(_ format: Date.DateFormat = .iso8601, timezone: TimeZone = .current, locale: Locale = .current) -> Date? {
//        let formatter = DateFormatter()
//        formatter.dateFormat = format.formatString
//        formatter.timeZone = timezone
//        formatter.locale = locale
//        return formatter.date(from: self)
//    }
//}

// Example Usage:
/*
 // Formatting dates
 let now = Date()
 print(now.toString(.shortDate))
 print(now.toString(.custom("MMMM yyyy")))
 
 // Date manipulation
 let tomorrow = Date().addingDays(1)
 let nextMonth = Date().addingMonths(1)
 
 // Date comparison
 if someDate.isToday {
     print("This is today!")
 }
 
 // Time ago
 let pastDate = Date().addingDays(-5)
 print(pastDate.timeAgo) // "5 days ago"
 print(pastDate.shortTimeAgo) // "5d ago"
 
 // Date ranges
 let dates = Date.dates(from: Date(), to: Date().addingDays(7))
 
 // String to Date conversion
 let dateString = "2025-09-08T10:00:00Z"
 if let date = dateString.toDate(.iso8601) {
     print(date.toString(.longDate))
 }
*/
