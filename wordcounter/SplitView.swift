//
//  SplitView.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import SwiftUI

struct SplitView: View {
    
    @State var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State var writing: FetchedResults<Writing>.Element?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            ListView(selected: $writing)
        } detail: {
            CounterView(writing: $writing)
        }
    }
}

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView()
    }
}
