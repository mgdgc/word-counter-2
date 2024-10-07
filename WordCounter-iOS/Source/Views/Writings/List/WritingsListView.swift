// 
//  WritingsListView.swift
//  WordCounter-iOS
//
//  Created by 최명근 on 10/8/24.
//

import SwiftUI
import ComposableArchitecture

struct WritingsListView: View {
    @Bindable var store: StoreOf<WritingsListFeature>

    var body: some View {
        Text(verbatim: "Hello, world!")
    }
}

#Preview {
    WritingsListView(
        store: Store(
            initialState: WritingsListFeature.State()
        ) {
            WritingsListFeature()
        }
    )
}
