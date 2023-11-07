//
//  DateValidator.swift
//  SwiftUI-DateDetector
//
//  Created by Theo Vora on 11/6/23.
//

import Foundation

public struct DateValidator {
    public init() { }
    
    public func isLeapYear(_ targetYear: Int) -> Bool {
        if targetYear % 4 != 0 { return false }
        if targetYear % 400 == 0 { return true }
        if targetYear % 100 == 0 { return false }
        return true
    }
}
