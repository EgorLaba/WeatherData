import Foundation
import CoreData

@objc(WeatherDescription)
public class WeatherDescription: NSManagedObject, Codable {
    
    @NSManaged public var id: Int
    @NSManaged public var main: String
    @NSManaged public var info: String
    @NSManaged public var icon: String
    
    // MARK: - Enum
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case info = "description"
        case icon
    }
    
    // Public init
    
    required public convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "WeatherDescription", in: managedObjectContext) else { fatalError("Failed to decode WeatherDescription!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(Int.self, forKey: .id)
        main = try values.decode(String.self, forKey: .main)
        info = try values.decode(String.self, forKey: .info)
        icon = try values.decode(String.self, forKey: .icon)
    }
    
    // Public func
    
    public func encode(to encoder: Encoder) throws {
        var contrainer = encoder.container(keyedBy: CodingKeys.self)

        try contrainer.encode(id, forKey: .id)
        try contrainer.encode(main, forKey: .main)
        try contrainer.encode(info, forKey: .info)
        try contrainer.encode(icon, forKey: .icon)
    }
}
