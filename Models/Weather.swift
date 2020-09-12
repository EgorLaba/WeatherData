
import UIKit

struct Weather: Codable {
    var current: WeatherParams
    var hourly: [WeatherParams]
    var daily: [Daily]
}

struct WeatherParams: Codable {
    var dt: Date?
    var sunrise: Date?
    var sunset: Date?
    var temp: Double
    var feels_like: Double
    var visibility: Int
    var pressure: Int
    var humidity: Int
    var wind_speed: Double
    var wind_deg: Int
    var weather: [WeatherDescription]
}

struct WeatherDescription: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Daily: Codable {
    var dt: Date
    var sunrise: Date
    var sunset: Date
    var temp: Temp
    var weather: [WeatherDescription]
}

struct Temp: Codable {
    var day: Double
    var night: Double
}
