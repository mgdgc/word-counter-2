//
//  PasscodeView.swift
//  wordcounter
//
//  Created by 최명근 on 11/16/23.
//

import SwiftUI
import LocalAuthentication

struct PasscodeView: View {
    enum AfterAction {
        case none
        case dismiss
        case retype(_ message: String)
    }
    
    enum PasscodePad: Hashable {
        case biometric
        case delete
        case number(Int)
    }
    
    // PasscodeView options
    private var dismissable: Bool
    private var biometric: Bool
    private var authenticateOnLaunch: Bool
    private var onPasswordEntered: (_ typed: String?, _ biometric: Bool?) -> AfterAction
    
    @State private var typed: [Int] = []
    @State private var temp: [Int] = []
    
    @State private var message: String
    
    @Environment(\.dismiss) var dismiss
    
    private let laContext: LAContext = LAContext()
    private let pads: [PasscodePad] = [
        .number(1), .number(2), .number(3),
        .number(4), .number(5), .number(6),
        .number(7), .number(8), .number(9),
        .biometric, .number(0), .delete
    ]
    
    init(initialMessage: String = "password_unlock".localized, dismissable: Bool = false, enableBiometric: Bool = true, authenticateOnLaunch: Bool = true, onPasswordEntered: @escaping (_ typed: String?, _ biometric: Bool?) -> AfterAction) {
        self._message = State(initialValue: initialMessage)
        self.dismissable = dismissable
        self.biometric = enableBiometric
        self.authenticateOnLaunch = authenticateOnLaunch
        self.onPasswordEntered = onPasswordEntered
    }
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text(message)
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.textPrimary)
                
                Spacer()
                
                HStack(spacing: 16) {
                    ForEach(0..<6) { number in
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.accentColor)
                            .opacity(number < typed.count ? 0.8 : 0.1)
                    }
                }
                
                Spacer()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), alignment: .center, spacing: 24) {
                    ForEach(pads, id: \.self) { pad in
                        switch pad {
                        case .number(let number):
                            self.numberButton(number: number)
                            
                        case .delete:
                            self.deleteButton
                            
                        case .biometric:
                            if biometric &&
                                UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lockBiometric) &&
                                laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) &&
                                laContext.biometryType != .none {
                                self.biometricButton
                                    .onAppear {
                                        if authenticateOnLaunch {
                                            authenticateViaBiometric()
                                        }
                                    }
                            } else {
                                Spacer()
                            }
                            
                        default:
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: 360, minHeight: 360)
                .padding()
            }
            .frame(maxHeight: 720)
            
            if dismissable {
                VStack {
                    HStack {
                        Button {
                            onPasswordEntered(nil, nil)
                            dismiss()
                            
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(Color.textSecondary)
                                .padding(8)
                                .background(
                                    Circle()
                                        .stroke(Color.textPrimary.opacity(0.4), lineWidth: 1)
                                )
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    private var biometricButton: some View {
        Button {
            authenticateViaBiometric()
            
        } label: {
            let icon: String = {
                if laContext.biometryType == .touchID {
                    return "touchid"
                } else if laContext.biometryType == .faceID {
                    return "faceid"
                } else if #available(iOS 17, *), laContext.biometryType == .opticID {
                    return "opticid"
                } else {
                    return "exclamationmark.triangle"
                }
            }()
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24)
            //                .padding(24)
                .foregroundStyle(Color.textSecondary)
        }
    }
    
    @ViewBuilder
    private var deleteButton: some View {
        Button {
            if !typed.isEmpty {
                typed.removeLast()
            }
            
        } label: {
            Image(systemName: "delete.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24)
                .foregroundStyle(Color.textSecondary)
        }
        .disabled(typed.isEmpty)
    }
    
    @ViewBuilder
    private func numberButton(number: Int) -> some View {
        Button {
            typed.append(number)
            
            if typed.count >= 6 {
                validate(typed: convert(array: typed), biometric: nil)
            }
            
        } label: {
            Text(String(format: "%d", number))
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(Color.textSecondary)
                .padding(24)
                .background(
                    Circle()
                        .stroke(Color.textPrimary.opacity(0.4), lineWidth: 1)
                )
        }
    }
    
    private func authenticateViaBiometric() {
        if laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "일기장 잠금 해제") { success, error in
                if let error = error {
                    print(error)
                }
                if success {
                    validate(typed: nil, biometric: true)
                }
            }
        }
    }
    
    private func convert(array: [Int]) -> String {
        var string = ""
        for i in array {
            string.append(String(i))
        }
        return string
    }
    
    private func validate(typed: String?, biometric: Bool?) {
        switch onPasswordEntered(typed, biometric) {
        case .none:
            break
            
        case .dismiss:
            dismiss()
            
        case .retype(let message):
            self.typed.removeAll()
            self.message = message
        }
    }
}

#Preview {
    PasscodeView(initialMessage: "Hello, world!", dismissable: false, enableBiometric: true, authenticateOnLaunch: true) { typed, biometric in
        return .retype("Retype")
    }
}
