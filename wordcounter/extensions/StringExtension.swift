//
//  StringExtension.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import Foundation

extension String {
    
    var localized: String {
        get {
            return NSLocalizedString(self, comment: "")
        }
    }
    
}
