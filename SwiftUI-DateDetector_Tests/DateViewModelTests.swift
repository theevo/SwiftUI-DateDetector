//
//  DateViewModelTests.swift
//  SwiftUI-DateDetector_Tests
//
//  Created by Theo Vora on 11/5/23.
//

import XCTest
@testable import SwiftUI_DateDetector

final class DateViewModelTests: XCTestCase {

    func test_yearZero_isNotValid() {
        let vm = buildDateVM("12310000")
        
        XCTAssertTrue(vm.monthValidity.isValid)
        XCTAssertTrue(vm.dayValidity.isValid)
        XCTAssertTrue(vm.yearValidity.notValid)
    }
    
    func test_month13_isNotValid() {
        let vm = buildDateVM("13312000")
        
        XCTAssertTrue(vm.monthValidity.notValid)
        XCTAssertTrue(vm.dayValidity.isValid)
        XCTAssertTrue(vm.yearValidity.isValid)
    }
    
    func test_month00_isNotValid() {
        let vm = buildDateVM("00312000")
        
        XCTAssertTrue(vm.monthValidity.notValid)
        XCTAssertTrue(vm.dayValidity.isValid)
        XCTAssertTrue(vm.yearValidity.isValid)
    }
    
    func test_day32_isNotValid() {
        let vm = buildDateVM("05322000")
        
        XCTAssertTrue(vm.monthValidity.isValid)
        XCTAssertTrue(vm.dayValidity.notValid)
        XCTAssertTrue(vm.yearValidity.isValid)
    }
    
    func test_day00_isNotValid() {
        let vm = buildDateVM("01002000")
        
        XCTAssertTrue(vm.monthValidity.isValid)
        XCTAssertTrue(vm.dayValidity.notValid)
        XCTAssertTrue(vm.yearValidity.isValid)
    }
    
    // MARK: - Helpers
    
    func buildDateVM(_ str: String) -> DateViewModel {
        let regex = #/
            (?<month> \d{2})
            (?<day> \d{2})
            (?<year> \d{4})
        /#
        
        if let match = str.firstMatch(of: regex) {
            let month = String(match.month)
            let day = String(match.day)
            let year = String(match.year)
            
            let vm = DateViewModel()
            vm.inputMonth = month
            vm.inputDay = day
            vm.inputYear = year
            
            return vm
        } else {
            fatalError("Invalid date passed as input. Must be 8 characters in length with the format MMDDYYYY")
        }
    }
}
