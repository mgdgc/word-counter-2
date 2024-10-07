// 
//  WritingsListView.swift
//  WordCounter-iOS
//
//  Created by 최명근 on 10/7/24.
//

import SwiftUI
import ComposableArchitecture

struct WritingsListView: View {
    @Bindable var store: StoreOf<WritingsListFeature>

    var body: some View {
        Text(String("Hello, world!"))
    }
}

#Preview {
    let initialState = WritingsListFeature.State()
    return WritingsListView(store: Store(initialState: initialState) {
        WritingsListFeature()
    })
}
