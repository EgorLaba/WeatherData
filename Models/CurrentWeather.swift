
import UIKit

struct CurrentWeather: Decodable {
    var visibility: Int
    var dt: Date
    var name: String
    var weather: [WeatherDescription]
    var main: MainParams
    var wind: Wind
    var sys: SysParams
}

struct WeatherDescription: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct MainParams: Decodable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}

struct Wind: Decodable {
    var speed: Double
    var deg: Int
}

struct SysParams: Decodable {
    var country: String
    var sunrise: Date
    var sunset: Date
}
