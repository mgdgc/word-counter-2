//
//  WritingPersistence.swift
//  wordcounter
//
//  Created by 최명근 on 10/8/24.
//

import Foundation
import SwiftData
import ComposableArchitecture

struct WritingClient {
    var fetchAll: @Sendable () throws -> [Writing]
    var fetch: @Sendable (FetchDescriptor<Writing>) throws -> [Writing]
    var insert: @Sendable (Writing) throws -> Void
    var delete: @Sendable (Writing) throws -> Void
    var save: @Sendable () throws -> Void
}

extension WritingClient: DependencyKey {
    static var liveValue: WritingClient = Self(
        fetchAll: {
            @Dependency(\.persistence.context) var context
            let writingContext = try context()
            let fetchDescriptor = FetchDescriptor<Writing>(sortBy: [SortDescriptor(\.updatedAt)])
            return try writingContext.fetch(fetchDescriptor)
        },
        fetch: { fetchDescriptor in
            @Dependency(\.persistence.context) var context
            let writingContext = try context()
            return try writingContext.fetch(fetchDescriptor)
        },
        insert: { writing in
            @Dependency(\.persistence.context) var context
            let writingContext = try context()
            writingContext.insert(writing)
        },
        delete: { writing in
            @Dependency(\.persistence.context) var context
            let writingContext = try context()
            writingContext.delete(writing)
        },
        save: {
            @Dependency(\.persistence.context) var context
            let writingContext = try context()
            try writingContext.save()
        }
    )
}
