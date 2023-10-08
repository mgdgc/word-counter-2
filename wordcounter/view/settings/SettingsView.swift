//
//  InfoView.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import SwiftUI
import UIKit
import LocalAuthentication

struct InfoCell: View {
    
    var title: LocalizedStringKey
    var content: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(Color(uiColor: .label))
            Spacer()
            Text(content)
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
    }
}

struct SettingsView: View {
    
    @State var lock: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock)
    @State var showBackup: Bool = false
    @State var showRestore: Bool = false
    
    @State var version: String = "v2.0"
    @State var build: String = "2023031800"
    
    private var lockable: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            List {
                Section {
                    Toggle("settings_security_lock", isOn: $lock)
                        .onChange(of: lock) { newValue in
                            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.Settings.lock)
                            UserDefaults.standard.synchronize()
                        }
                        .disabled(!lockable)
                } header: {
                    Text("settings_section_security")
                    
                } footer : {
                    lockable ? Text("settings_section_security_footer") : Text("settings_section_security_footer_error")
                }
                
                Section("info_section_app") {
                    InfoCell(title: "info_version", content: version)
                    InfoCell(title: "info_build", content: build)
                }
                
            }
        }
        .onAppear {
            // 애플리케이션 버전
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                self.version = version
            }
            
            // 빌드 버전
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                self.build = build
            }
        }
        .navigationTitle("setting_title")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("dismiss") {
                    dismiss()
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}


