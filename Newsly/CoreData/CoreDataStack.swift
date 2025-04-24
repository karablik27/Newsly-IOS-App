import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved Core Data error: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext { container.viewContext }

    func saveContext() {
        let ctx = context
        if ctx.hasChanges {
            do { try ctx.save() }
            catch { print("CoreData save error:", error) }
        }
    }
}
