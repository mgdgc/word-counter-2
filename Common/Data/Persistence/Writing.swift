//
//  Writing.swift
//  wordcounter
//
//  Created by 최명근 on 10/7/24.
//

import Foundation
import SwiftData

@Model
class Writing {
    @Attribute(.unique) var id: String = UUID().uuidString
    var text: String = ""
    var timestamp: Date = Date()
}

extension Writing: Identifiable { }
