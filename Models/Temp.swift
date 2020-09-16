import Foundation
import CoreData

@objc(Temp)
public class Temp: NSManagedObject, Codable {
    
    @NSManaged public var day: Double
    @NSManaged public var night: Double
    @NSManaged public var max: Double
    
    // MARK: Enum

    enum CodingKeys: String, CodingKey {
        case day
        case night
        case max
    }
    
    // Public init
    
    required public convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Temp", in: managedObjectContext) else { fatalError("Failed to decode Temp!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)

        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        day = try values.decode(Double.self, forKey: .day)
        night = try values.decode(Double.self, forKey: .night)
        max = try values.decode(Double.self, forKey: .max)
    }
    
    // Public func
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(day, forKey: .day)
        try container.encode(night, forKey: .night)
        try container.encode(max, forKey: .max)
    }
}
