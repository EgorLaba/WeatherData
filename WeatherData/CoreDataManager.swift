import Foundation
import CoreData

class CoreDataManager {
    static let sharedInstance = CoreDataManager()
    private let modelName = "DataBase"
    
    // MARK: - Core Data stack

    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "\(modelName).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            print(error)
            fatalError("Unable to Load Persistent Store")
        }

        return persistentStoreCoordinator
    }()
    
    // MARK: - Core Data Saving support

    func saveContext() {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError 
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Public func
    
    func getWeather() -> Weather? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        return try? managedObjectContext.fetch(fetchRequest).first as? Weather
    }
    
    func deleteAllWeather() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        let weathers = try? managedObjectContext.fetch(fetchRequest) as? [Weather]
        weathers?.forEach({ (weather) in
            managedObjectContext.delete(weather)
        })
    }
}

