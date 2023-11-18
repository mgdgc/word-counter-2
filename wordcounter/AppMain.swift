//
//  AppMain.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/18.
//

import Foundation
import SwiftUI

@main
struct AppMain: App {
    
    let persistenceController = PersistenceController.shared
    
    init() {
        UserDefaults.standard.register(defaults: [
            UserDefaultsKey.Settings.lock : false,
            UserDefaultsKey.Settings.lockBiometric : false,
            UserDefaultsKey.Settings.lockImmediately : false
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            SplitView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
}
