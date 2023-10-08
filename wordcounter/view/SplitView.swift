//
//  SplitView.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import SwiftUI
import LocalAuthentication

struct SplitView: View {
    
    @State var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State var writing: FetchedResults<Writing>.Element?
    @State private var locked: Bool = false
    @State private var lockMessage: String = "split_locked_message".localized
    
    private let laContext = LAContext()
    
    var body: some View {
        ZStack {
            splitView
                .overlay {
                    if locked {
                        ZStack {
                            Rectangle()
                                .fill(.regularMaterial)
                                .ignoresSafeArea()
                            
                            VStack(spacing: 16) {
                                Text("split_locked")
                                    .font(.title.bold())
                                Text(lockMessage)
                                    .font(.body)
                                Button(action: unlock) {
                                    Label("split_locked_button", systemImage: "lock.open")
                                }
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                                .padding(.top, 16)
                            }
                        }
                    }
                }
                .onAppear {
                    locked = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock) && laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
                }
        }
    }
    
    private var splitView: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            ListView(selected: $writing, columnVisibility: $columnVisibility)
        } detail: {
            CounterView(writing: $writing, columnVisibility: $columnVisibility)
        }
    }
    
    private func unlock() {
        var error: NSError?
        let reason = "split_locked_biometric_reason".localized
        if laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if let error = error {
                    print(error)
                    lockMessage = error.localizedDescription
                } else {
                    self.locked = !success
                }
            }
        }
    }
}

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView()
    }
}
