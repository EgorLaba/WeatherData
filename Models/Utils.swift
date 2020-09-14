
import UIKit

class Utils {
    
    static func getWindDirection(_ wind: Int) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i = Int((Float(wind) + 11.25) / 22.5)
        return directions[i % 16]
    }
}
