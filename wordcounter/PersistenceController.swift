//
//  WritingDataHelper.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import Foundation
import UIKit
import CoreData

class PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    // MARK: - Init
    private init() {
        self.container = NSPersistentContainer(name: "wordcounter")
        self.container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
    }
    
    // MARK: Save Context
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    // MARK: - Save
//    func save(id: String = UUID().uuidString, text: String, timestamp: Date = Date()) {
//        guard let entity = NSEntityDescription.entity(forEntityName: "Writing", in: container.viewContext) else {
//            return
//        }
//
//        let writing = NSManagedObject(entity: entity, insertInto: container.viewContext)
//        writing.setValue(id, forKey: "id")
//        writing.setValue(text, forKey: "text")
//        writing.setValue(timestamp, forKey: "timestamp")
//
//        do {
//            try container.viewContext.save()
//        } catch {
//            Log.p(error, field: "WritingDataHelper::save")
//        }
//    }
//
//    // MARK: Fetch All
//    func fetch() -> [Writing]? {
//        do {
//            let writings = try container.viewContext.fetch(Writing.fetchRequest()) as! [Writing]
//            return writings
//        } catch {
//            Log.p(error, field: "WritingDataHelper::fetch")
//            return nil
//        }
//    }
//    
//    func fetch(id: String) -> Writing? {
//        do {
//            let writing = try container.viewContext.fetch
//        }
//    }
    
}
