//
//  DateValidatorTests.swift
//  SwiftUI-DateDetector_Tests
//
//  Created by Theo Vora on 11/6/23.
//

import XCTest
import SwiftUI_DateDetector

final class DateValidatorTests: XCTestCase {
    func test_isLeapYear_returnsTrueWithValidLeapYear() {
        let dv = DateValidator()
        
        XCTAssertTrue(dv.isLeapYear(1996))
        XCTAssertTrue(dv.isLeapYear(2000))
        XCTAssertTrue(dv.isLeapYear(2004))
    }
    
    func test_isLeapYear_givenYearsNotDivisibleBy4_returnsFalse() {
        let dv = DateValidator()
        
        XCTAssertFalse(dv.isLeapYear(1977))
        XCTAssertFalse(dv.isLeapYear(1997))
        XCTAssertFalse(dv.isLeapYear(2001))
    }
    
    func test_isLeapYear_givenYearsNotDivisibleBy400ButAreDivisibleBy100_returnsFalse() {
        let dv = DateValidator()
        
        XCTAssertFalse(dv.isLeapYear(1800))
        XCTAssertFalse(dv.isLeapYear(1900))
        XCTAssertFalse(dv.isLeapYear(2100))
    }
}
