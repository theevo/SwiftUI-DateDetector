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
        
        XCTAssertTrue(vm.yearValidity.notValid)
    }
    
    func test_month13_isNotValid() {
        let vm = buildDateVM("13312000")
        
        XCTAssertTrue(vm.monthValidity.notValid)
    }
    
    func test_month00_isNotValid() {
        let vm = buildDateVM("00312000")
        
        XCTAssertTrue(vm.monthValidity.notValid)
    }
    
    func test_day32_isNotValid() {
        let vm = buildDateVM("05322000")
        
        XCTAssertTrue(vm.dayValidity.notValid)
    }
    
    func test_day00_isNotValid() {
        let vm = buildDateVM("01002000")
        
        XCTAssertTrue(vm.dayValidity.notValid)
    }
    
    func test_validDates_areValid() {
        let vm1 = buildDateVM("10311947")
        
        XCTAssertTrue(vm1.monthValidity.isValid)
        XCTAssertTrue(vm1.dayValidity.isValid)
        XCTAssertTrue(vm1.yearValidity.isValid)
        
        let vm2 = buildDateVM("06051980")
        
        XCTAssertTrue(vm2.monthValidity.isValid)
        XCTAssertTrue(vm2.dayValidity.isValid)
        XCTAssertTrue(vm2.yearValidity.isValid)
        
        let vm3 = buildDateVM("09101985")
        
        XCTAssertTrue(vm3.monthValidity.isValid)
        XCTAssertTrue(vm3.dayValidity.isValid)
        XCTAssertTrue(vm3.yearValidity.isValid)
    }
    
    func test_leapYearDate_isValid() {
        let vm = buildDateVM("02292000")
        let expectation = "February 29, 2000"
        vm.previewDate()
        
        XCTAssertTrue(vm.previewBirthdate == expectation, "Expected \(expectation) but received this instead: \(vm.previewBirthdate)")
    }
    
    func test_april31_isNotValid() {
        let vm = buildDateVM("04312000")
        
        XCTAssertTrue(vm.dayValidity.notValid)
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
