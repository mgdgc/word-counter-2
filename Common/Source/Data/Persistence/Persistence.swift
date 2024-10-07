//
//  Persistence.swift
//  wordcounter
//
//  Created by 최명근 on 10/7/24.
//

import Foundation
import SwiftData

struct Persistence {
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Writing.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            groupContainer: .automatic,
            cloudKitDatabase: .private("wordcountercloud")
        )
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    static var sharedModelContext: ModelContext = ModelContext(sharedModelContainer)
    
    static var debugModelContainer: ModelContainer = {
        let schema = Schema([
            Writing.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true,
            groupContainer: .automatic,
            cloudKitDatabase: .private("wordcountercloud")
        )
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    static var debugModelContext: ModelContext = ModelContext(sharedModelContainer)
}
