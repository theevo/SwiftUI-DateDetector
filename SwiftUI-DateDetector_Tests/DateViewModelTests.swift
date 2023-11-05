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
        let vm = DateViewModel()
        
        vm.inputMonth = "12"
        vm.inputDay = "31"
        vm.inputYear = "0000"
        
        XCTAssertTrue(vm.monthValidity.isValid)
        XCTAssertTrue(vm.dayValidity.isValid)
        XCTAssertFalse(vm.yearValidity.isValid)
    }
}
