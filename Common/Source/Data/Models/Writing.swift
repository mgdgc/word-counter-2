//
//  Writing.swift
//  wordcounter
//
//  Created by 최명근 on 10/7/24.
//

import Foundation
import SwiftData


typealias Writing = WordCounterSchemaV2.Writing


// MARK: - Schema V1

enum WordCounterSchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] = [Writing.self]
    
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
    
    @Model
    final class Writing: Identifiable {
        var id: String?
        var text: String?
        var timestamp: Date?
        
        init() { }
    }
}


// MARK: - Schema V1

enum WordCounterSchemaV2: VersionedSchema {
    static var models: [any PersistentModel.Type] = [Writing.self]
    
    static var versionIdentifier: Schema.Version = .init(2, 0, 0)
    
    @Model
    final class Writing: Identifiable {
        @Attribute(.unique) var id: UUID = UUID()
        var text: String = ""
        var createdAt: Date = Date()
        var updatedAt: Date = Date()
        
        init() { }
    }
}


// MARK: - Migration Plan

enum WordCounterMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] = [
        WordCounterSchemaV1.self, WordCounterSchemaV2.self
    ]
    
    static var stages: [MigrationStage] = [
        migrateV1ToV2
    ]
    
    static let migrateV1ToV2: MigrationStage = .custom(
        fromVersion: WordCounterSchemaV1.self,
        toVersion: WordCounterSchemaV2.self
    ) { context in
        do {
            let oldData = try context.fetch(FetchDescriptor<WordCounterSchemaV1.Writing>())
            
            for writing in oldData {
                let newWriting = WordCounterSchemaV2.Writing()
                if let id = writing.id {
                    newWriting.id = UUID(uuidString: id) ?? UUID()
                }
                newWriting.text = writing.text ?? ""
                newWriting.createdAt = writing.timestamp ?? Date()
                newWriting.updatedAt = writing.timestamp ?? Date()
                
                context.insert(newWriting)
            }
            try context.save()
            
        } catch {
            debugPrint("SwiftData migration failed: \(error.localizedDescription)")
        }
    } didMigrate: { context in
        debugPrint("SwiftData migration succeeded")
    }
}
