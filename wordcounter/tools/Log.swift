//
//  Log.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import Foundation

class Log {
    
    static func d(_ message: String, field: String) {
        #if DEBUG
        p(message, field: field)
        #endif
    }
    
    static func p(_ items: Any..., field: String) {
        #if DEBUG
        print("\n----- \(field) -----")
        print(Date().fullString)
        print("\n")
        print(items)
        print("\n")
        #endif
    }
    
}
