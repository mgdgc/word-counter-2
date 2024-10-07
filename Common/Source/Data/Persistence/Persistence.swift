//
//  Persistence.swift
//  wordcounter
//
//  Created by 최명근 on 10/8/24.
//

import Foundation
import SwiftData
import ComposableArchitecture

struct Persistence {
    var context: () throws -> ModelContext
}

extension Persistence: DependencyKey {
    @MainActor
    static var liveValue: Persistence = Self(
        context: { appContext }
    )
}

extension DependencyValues {
    var persistence: Persistence {
        get { self[Persistence.self] }
        set { self[Persistence.self] = newValue }
    }
}
