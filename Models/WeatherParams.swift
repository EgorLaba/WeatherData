import Foundation
import CoreData

@objc(WeatherParams)
public class WeatherParams: NSManagedObject, Codable {
    

    @NSManaged public var dt: Date
    @NSManaged public var sunrise: Date?
    @NSManaged public var sunset: Date?
    @NSManaged public var temp: Double
    @NSManaged public var feelsLike: Double
    @NSManaged public var humidity: Int
    @NSManaged public var visibility: Int
    @NSManaged public var pressure: Int
    @NSManaged public var windSpeed: Double
    @NSManaged public var windDeg: Int
    @NSManaged public var weather: NSSet
    
    // MARK: - Enum
    
    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case feelsLike = "feels_like"
        case humidity
        case visibility
        case pressure
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
    
    // Public init
    
    required public convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "WeatherParams", in: managedObjectContext) else { fatalError("Failed to decode WeatherParams!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)

        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        dt = try values.decode(Date.self, forKey: .dt)
        sunrise = try? values.decode(Date.self, forKey: .sunrise)
        sunset = try? values.decode(Date.self, forKey: .sunset)
        temp = try values.decode(Double.self, forKey: .temp)
        feelsLike = try values.decode(Double.self, forKey: .feelsLike)
        humidity = try values.decode(Int.self, forKey: .humidity)
        visibility = try values.decode(Int.self, forKey: .visibility)
        pressure = try values.decode(Int.self, forKey: .pressure)
        windSpeed = try values.decode(Double.self, forKey: .windSpeed)
        windDeg = try values.decode(Int.self, forKey: .windDeg)
        let weatherArray = try values.decode([WeatherDescription].self, forKey: .weather)
        weather = NSSet(array: weatherArray)
    }
    
    // Public func
    
    public func encode(to encoder: Encoder) throws {
        var contrainer = encoder.container(keyedBy: CodingKeys.self)

        try contrainer.encode(dt, forKey: .dt)
        try contrainer.encode(sunrise, forKey: .sunrise)
        try contrainer.encode(sunset, forKey: .sunset)
        try contrainer.encode(feelsLike, forKey: .feelsLike)
        try contrainer.encode(humidity, forKey: .humidity)
        try contrainer.encode(visibility, forKey: .visibility)
        try contrainer.encode(pressure, forKey: .pressure)
        try contrainer.encode(windSpeed, forKey: .windSpeed)
        try contrainer.encode(windDeg, forKey: .windDeg)
        
        let weatherArray = weather.allObjects as? [WeatherDescription]
        try contrainer.encode(weatherArray, forKey: .weather)
    }
}
