
import UIKit

extension Date {
    static func dayOfWeek(_ dt: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: dt).capitalized
    }
    
    static func hourlyData(_ dt: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        return dateFormatter.string(from: dt)
    }
}
