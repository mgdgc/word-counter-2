//
//  DateExtension.swift
//  hallym-taxi
//
//  Created by 최명근 on 2023/02/09.
//

import Foundation

extension Date {
    
    init(timeInMillis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(timeInMillis) / 1000)
    }
    
    init(timeInMillis: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(timeInMillis) / 1000)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    var dateString: String {
        return "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
    }
    
    var timeString: String {
        return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
    }
    
    var timeInMillis: Int64 {
        get {
            return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        }
    }
    
}
