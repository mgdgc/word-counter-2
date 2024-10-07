// 
//  AppView.swift
//  WordCounter-iOS
//
//  Created by 최명근 on 10/7/24.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        Text(String("Hello, world!"))
    }
}

#Preview {
    let initialState = AppFeature.State()
    return AppView(store: Store(initialState: initialState) {
        AppFeature()
    })
}
