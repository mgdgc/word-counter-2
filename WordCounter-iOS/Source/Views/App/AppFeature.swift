// 
//  AppFeature.swift
//  WordCounter-iOS
//
//  Created by 최명근 on 10/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
    
    // MARK: State
    
    @ObservableState
    struct State: Equatable {
        // Properties

        // View States

        // Presentation
    }

    // MARK: Action
    
    enum Action {
        // Functional Actions

        // State Modifications

        // View Actions

        // Presentation Actions
    }

    // MARK: Reducer
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            // Functional Actions

            // State Modifications

            // View Actions

            // Presentation Actions

            default: return .none
            }
        }
    }
}
