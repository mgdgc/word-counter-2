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
    
    let container: NSPersistentCloudKitContainer
    
    // MARK: - Init
    private init() {
        self.container = NSPersistentCloudKitContainer(name: "wordcounter")
        self.container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        self.container.viewContext.automaticallyMergesChangesFromParent = true
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
}
