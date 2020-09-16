import Foundation
import CoreData

@objc(Weather)
public class Weather: NSManagedObject, Codable {
    
    @NSManaged public var current: WeatherParams
    @NSManaged public var hourly: NSSet
    @NSManaged public var daily: NSSet
    
    // MARK: - Enum
    
    enum CodingKeys: String, CodingKey {
        case current
        case hourly
        case daily
    }
    
    // Public init
    
    required public convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Weather", in: managedObjectContext) else { fatalError("Failed to decode Weather!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        current = try values.decode(WeatherParams.self, forKey: .current)
        
        let hourlyArray = try values.decode([WeatherParams].self, forKey: .hourly)
        hourly = NSSet(array: hourlyArray)

        let dailyArray = try values.decode([Daily].self, forKey: .daily)
        daily = NSSet(array: dailyArray)
    }

    // Public func

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(current, forKey: .current)

        let hourlyArray = hourly.allObjects as? [WeatherParams]
        try container.encode(hourlyArray, forKey: .hourly)
        
        let dailyArray = daily.allObjects as? [Daily]
        try container.encode(dailyArray, forKey: .daily)
    }
}
