//
//  InfoView.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import SwiftUI
import UIKit
import LocalAuthentication
import CloudKit
import SwiftKeychainWrapper

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
    @State var version: String = "v2.0"
    @State var build: String = "2023031800"
    
    @State var iCloudAvailable: Bool = false
    
    @State var lock: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock)
    @State var lockBiometric: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lockBiometric)
    @State var lockImmediately: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lockImmediately)
    
    @State var passcode: String = ""
    @State var showPasscodeView: Bool = false
    
    private var biometricEnabled: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            List {
                // MARK: - iCloud
                Section {
                    Label {
                        Text(iCloudAvailable ? "settings_icloud_available" : "settings_icloud_unavailable")
                    } icon: {
                        Image(systemName: iCloudAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                    }

                } header: {
                    Text("settings_section_icloud")
                } footer: {
                    Text(iCloudAvailable ? "settings_section_icloud_available" : "settings_section_icloud_unavailable")
                }
                
                // MARK: - Security
                Section {
                    Toggle("settings_security_lock", isOn: $lock)
                        .onChange(of: lock) { newValue in
                            if newValue {
                                if passcode.isEmpty {
                                    showPasscodeView = true
                                    lock = false
                                }
                                
                            } else {
                                KeychainWrapper.standard.remove(forKey: .passcode)
                                passcode = ""
                            }
                            
                            UserDefaults.standard.set(lock, forKey: UserDefaultsKey.Settings.lock)
                            UserDefaults.standard.synchronize()
                        }
                    
                    if biometricEnabled {
                        Toggle("settings_security_lock_biometric", isOn: $lockBiometric)
                            .onChange(of: lockBiometric) { newValue in
                                UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.Settings.lockBiometric)
                                UserDefaults.standard.synchronize()
                            }
                            .disabled(!lock)
                    }
                    
                    Toggle("settings_security_lock_immediately", isOn: $lockImmediately)
                        .onChange(of: lockImmediately) { newValue in
                            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.Settings.lockImmediately)
                            UserDefaults.standard.synchronize()
                        }
                        .disabled(!lock)
                } header: {
                    Text("settings_section_security")
                    
                } footer : {
                    if lockImmediately {
                        Text("settings_section_security_footer_immediately")
                    } else {
                        Text("settings_section_security_footer")
                    }
                }
                
                // MARK: - App Info
                Section("info_section_app") {
                    InfoCell(title: "info_version", content: version)
                    InfoCell(title: "info_build", content: build)
                    NavigationLink("info_license", destination: LicensesView())
                }
            }
        }
        .fullScreenCover(isPresented: $showPasscodeView) {
            lock = !passcode.isEmpty
            
        } content: {
            PasscodeView(initialMessage: "passcode_set".localized, dismissable: true, enableBiometric: false, authenticateOnLaunch: false) { typed, biometric in
                if passcode.isEmpty {
                    passcode = typed ?? ""
                    return .retype("passcode_set_check".localized)
                } else {
                    if passcode == typed {
                        KeychainWrapper.standard[.passcode] = passcode
                        lock = true
                        showPasscodeView = false
                        return .dismiss
                    } else {
                        passcode = ""
                        return .retype("passcode_set_fail".localized)
                    }
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
            
            // iCloud
            CKContainer.default().accountStatus { status, error in
                if let error = error {
                    print(error)
                }
                
                iCloudAvailable = status == .available
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


