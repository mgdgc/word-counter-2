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
    
    var body: some Scene {
        WindowGroup {
            SplitView()
        }
    }
    
}
