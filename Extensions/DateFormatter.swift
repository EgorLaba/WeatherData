
import UIKit

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    func hourlyData() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        return dateFormatter.string(from: self)
    }
}
