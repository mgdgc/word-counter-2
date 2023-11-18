//
//  SplitView.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import SwiftUI
import LocalAuthentication
import SwiftKeychainWrapper

struct SplitView: View {
    
    @State var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State var writing: Writing?
    @State private var locked: Bool = false
    @State private var lockMessage: String = "split_locked_message".localized
    
    @Environment(\.scenePhase) var scenePhase
    
    private let laContext = LAContext()
    
    var body: some View {
        ZStack {
            splitView
                .onAppear {
                    locked = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock) && laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
                }
                .onChange(of: scenePhase) { newValue in
                    switch newValue {
                    case .background:
                        if UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lockImmediately) {
                            locked = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock) && laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
                        }
                    case .inactive: break
                    case .active: break
                    @unknown default: break
                    }
                }
                .fullScreenCover(isPresented: $locked) {
                    PasscodeView(initialMessage: "passcode_unlock".localized, dismissable: false, enableBiometric: true, authenticateOnLaunch: true) { typed, biometric in
                        if biometric == true || typed == KeychainWrapper.standard[.passcode] {
                            locked = false
                            return .dismiss
                        } else {
                            return .retype("passcode_wrong".localized)
                        }
                    }
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
