//
//  WordCounter_iOSApp.swift
//  WordCounter-iOS
//
//  Created by 최명근 on 10/7/24.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct WordCounterApp: App {
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: WordCounterApp.store)
        }
        .modelContainer(PersistenceProvider.shared.container)
    }
}
