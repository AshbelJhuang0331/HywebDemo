//
//  CoreDataStack.swift
//  HywebDemo
//
//  Created by Chuan-Jie Jhuang on 2022/6/7.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {

    // MARK: - Core Data Stack
    
    static let sharedInstance = CoreDataStack()
    private override init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HywebDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving Support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Operations
    
    func destroyAllData() {
        let storeContainer =
            persistentContainer.persistentStoreCoordinator
        for store in storeContainer.persistentStores {
            do {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            } catch {
                print(error.localizedDescription)
            }
        }

        persistentContainer = NSPersistentContainer(
            name: "HywebDemo"
        )

        persistentContainer.loadPersistentStores {
            (store, error) in
            // Handle errors
        }
    }
    
    func fetchAllBooks() throws -> [Book] {
        let fetchRequest: NSFetchRequest<Book>
        fetchRequest = Book.fetchRequest()
        let uuidSortDescriptor = NSSortDescriptor(key: "uuid", ascending: true)
        fetchRequest.sortDescriptors = [uuidSortDescriptor]
        
        let context = persistentContainer.viewContext

        return try context.fetch(fetchRequest)
    }
    
    func deleteAllBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Book")

        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )

        deleteRequest.resultType = .resultTypeObjectIDs

        let context = persistentContainer.viewContext
        
        do {
            let batchDelete = try context.execute(deleteRequest)
                as? NSBatchDeleteResult

            guard let deleteResult = batchDelete?.result
                as? [NSManagedObjectID]
                else { return }

            let deletedObjects: [AnyHashable: Any] = [
                NSDeletedObjectsKey: deleteResult
            ]

            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects,
                into: [context]
            )
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchAllFavorites() throws -> [Favorite] {
        let fetchRequest: NSFetchRequest<Favorite>
        fetchRequest = Favorite.fetchRequest()

        let context = persistentContainer.viewContext

        return try context.fetch(fetchRequest)
    }
        
    func fetchBookByUUID(_ uuid: Int64) -> Book? {
        let fetchRequest: NSFetchRequest<Book>
        fetchRequest = Book.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "uuid == %d", uuid
        )
        
        let context = persistentContainer.viewContext

        let books = try? context.fetch(fetchRequest)
        return books?.first
    }
        
    func fetchFavoriteByUUID(_ uuid: Int64) -> Favorite? {
        let fetchRequest: NSFetchRequest<Favorite>
        fetchRequest = Favorite.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "uuid == %d", uuid
        )
        
        let context = persistentContainer.viewContext

        let favorites = try? context.fetch(fetchRequest)
        return favorites?.first
    }
    
    func insertFavoriteByUUID(_ uuid: Int64) {
        if (self.fetchFavoriteByUUID(uuid) == nil) {
            let context = persistentContainer.viewContext
            let favorite = Favorite(context: context)
            favorite.uuid = uuid
            do {
                try context.save()
            } catch {
                print("Could not save.", error.localizedDescription)
            }
        }
    }
    
    func deleteFavoriteByUUID(_ uuid: Int64) {
        if let existFavorite = self.fetchFavoriteByUUID(uuid) {
            let context = persistentContainer.viewContext
            context.delete(existFavorite)
            do {
                try context.save()
            } catch {
                print("Could not save.", error.localizedDescription)
            }
        }
    }
}
