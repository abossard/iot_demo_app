import Foundation
import CoreData

class DataService: NSObject {
    
    //var managedObjectContext: NSManagedObjectContext
    
    init(completionClosure: @escaping()->()) {
        let persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data Stack: \(error)")
            }
            //self.managedObjectContext = persistentContainer.viewContext
            completionClosure()
        }
    }
}
