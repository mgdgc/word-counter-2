// 
//  WritingsListFeature.swift
//  WordCounter-iOS
//
//  Created by 최명근 on 10/8/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WritingsListFeature {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
    }
}
