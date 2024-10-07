//
//  PersistenceProvider.swift
//  wordcounter
//
//  Created by 최명근 on 10/8/24.
//

import Foundation
import SwiftData
import ComposableArchitecture

class PersistenceProvider {
    #if targetEnvironment(simulator)
    static let shared = PersistenceProvider(isStoredInMemoryOnly: true, autosaveEnabled: true)
    #else
    static let shared = PersistenceProvider(isStoredInMemoryOnly: false, autosaveEnabled: true)
    #endif
    
    var isStoredInMemoryOnly: Bool
    var autosaveEnabled: Bool
    
    private init(isStoredInMemoryOnly: Bool, autosaveEnabled: Bool) {
        self.isStoredInMemoryOnly = isStoredInMemoryOnly
        self.autosaveEnabled = autosaveEnabled
    }
    
    @MainActor
    lazy var container: ModelContainer = {
        let schema = Schema([
            WordCounterSchemaV2.Writing.self
        ])
        
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isStoredInMemoryOnly,
            groupContainer: .automatic,
            cloudKitDatabase: .private("wordcountercloud")
        )
        
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            container.mainContext.autosaveEnabled = autosaveEnabled
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}

@MainActor
let appContext: ModelContext = {
    let container = PersistenceProvider.shared.container
    let context = ModelContext(container)
    return context
}()
