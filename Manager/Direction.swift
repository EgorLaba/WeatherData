
import UIKit

class Direction {
    
    static func getWindDirection(_ wind: Int) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let index = Int((Float(wind) + 11.25) / 22.5)
        return directions[index % 16]
    }
}
