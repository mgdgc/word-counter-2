//
//  UserDefaultsKey.swift
//  wordcounter
//
//  Created by 최명근 on 10/6/23.
//

import Foundation

class UserDefaultsKey {
    class Settings {
        
    }
}

extension UserDefaultsKey.Settings {
    static let lock = "lock_app"
    static let lockBiometric = "lock_biometric"
    static let lockImmediately = "lock_immediately"
}
