import Foundation
import CoreData

@objc(Daily)
public class Daily: NSManagedObject, Codable {
    
    @NSManaged public var dt: Date
    @NSManaged public var sunrise: Date
    @NSManaged public var sunset: Date
    @NSManaged public var weather: NSSet
    @NSManaged public var temp: Temp
    
    // MARK: - Enum
    
    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case weather
        case temp
    }
    
    // Public init

    required public convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Daily", in: managedObjectContext) else { fatalError("Failed to decode Daily!")
        } 
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        dt = try values.decode(Date.self, forKey: .dt)
        sunrise = try values.decode(Date.self, forKey: .sunrise)
        sunset = try values.decode(Date.self, forKey: .sunset)
        
        let weatherArray = try values.decode([WeatherDescription].self, forKey: .weather)
        weather = NSSet(array: weatherArray)
        
        temp = try values.decode(Temp.self, forKey: .temp)
    }
    
    // Public func

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dt, forKey: .dt)
        try container.encode(sunrise, forKey: .sunrise)
        try container.encode(sunset, forKey: .sunset)
        
        let weatherArray = weather.allObjects as? [WeatherDescription]
        try container.encode(weatherArray, forKey: .weather)
        
        try container.encode(temp, forKey: .temp)
    }
}
