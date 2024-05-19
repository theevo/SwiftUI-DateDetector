//
//  DateViewModel.swift
//  SwiftUI-DateDetector
//
//  Created by Theo Vora on 11/5/23.
//

import Foundation
import SwiftDate

@Observable class DateViewModel {
    var inputMonth: String = ""
    var inputDay: String = ""
    var inputYear: String = ""
    var monthFieldStyle = DatePartStyle()
    var dayFieldStyle = DatePartStyle()
    var yearFieldStyle = DatePartStyle()
    var monthValidity: FieldValidity {
        get {
            return validityOfMonth()
        }
    }
    var dayValidity: FieldValidity {
        get {
            return validityOfDay()
        }
    }
    var yearValidity: FieldValidity {
        get {
            return validityOfYear()
        }
    }
    var isValid: Bool {
        yearValidity == .Valid && monthValidity == .Valid && dayValidity == .Valid
    }
    private(set) var previewBirthdate: String = " "
    
    
    // MARK: - Public Methods
    
    public convenience init(
        month inputMonth: String,
        day inputDay: String,
        year inputYear: String) {
        self.init()
        self.inputMonth = inputMonth
        self.inputDay = inputDay
        self.inputYear = inputYear
    }
    
    public func canAdvance(from focus: DateEntryView.FocusedField?) -> Bool {
        switch focus {
        case .month:
            return monthValidity.isValid
        case .day:
            return dayValidity.isValid
        case .year:
            return yearValidity.isValid
        case .none:
            return false
        }
    }
    
    func clearPreview() {
        print("clearing '\(previewBirthdate)'")
        previewBirthdate = " "
    }
    
    func previewDate() {
        switch (validityOfMonth(), validityOfDay(), validityOfYear()) {
        case (.Valid, .Incomplete, _),
            (.Valid, .Invalid, _):
            previewMonthOnly()
        case (.Valid, .Valid, .Incomplete),
            (.Valid, .Valid, .Invalid):
            previewMonthAndDay()
        case (.Valid, .Valid, .Valid):
            previewEntireDate()
        default:
            clearPreview()
        }
    }
    
    func updateColors() {
        monthFieldStyle = DatePartStyle(color: monthValidity.color)
        
        dayFieldStyle = DatePartStyle(color: dayValidity.color)
        
        yearFieldStyle = DatePartStyle(color: yearValidity.color)
    }
    
    // MARK: - Private
    
    private func isValidInput(str: String) -> Bool {
        if str.isEmpty { return true }
        
        for char in str {
            if !DateViewModel.validCharacters.contains(char) {
                return false
            }
        }
        
        return true
    }
    
    private func previewEntireDate() {
        let newValue = inputMonth + inputDay + inputYear
        guard newValue.count == 8,
              let possibleDate = newValue.toDate("MMddyyyy")
        else { return }
        
        let dateToPreview = possibleDate.toFormat("MMMM dd, yyyy")
        
        if userInputMatches(date: possibleDate) {
            previewBirthdate = dateToPreview
        } else {
            previewMonthOnly()
        }
    }
    
    private func previewMonthAndDay() {
        let newValue = inputMonth + inputDay
        guard let possibleDate = newValue.toDate("MMdd") else { return }
        
        previewBirthdate = possibleDate.toFormat("MMMM dd")
    }
    
    private func previewMonthOnly() {
        let newValue = inputMonth
        guard newValue.count == 2,
              let possibleDate = newValue.toDate("MM")
        else { return }
        
        previewBirthdate = possibleDate.toFormat("MMMM")
    }
    
    private func validityOfDay() -> DateViewModel.FieldValidity {
        guard isValidInput(str: inputDay) else { return .Invalid }
        
        if inputDay.count < 2 {
            return .Incomplete
        } else if inputDay.count == 2,
                  (1...31).contains(Int(inputDay) ?? 0) {
            if monthValidity.isValid {
                let newValue = inputMonth + inputDay
                guard let possibleDate = newValue.toDate("MMdd"),
                      userInputMatches(date: possibleDate)
                else { return .Invalid }
                return .Valid
            } else {
                return .Valid
            }
        } else {
            print("\(inputDay) is an invalid day")
            return .Invalid
        }
    }
    
    private func validityOfMonth() -> DateViewModel.FieldValidity {
        guard isValidInput(str: inputMonth) else { return .Invalid }
        
        if inputMonth.count < 2 {
            return .Incomplete
        } else if inputMonth.count == 2,
                  (1...12).contains(Int(inputMonth) ?? 0) {
            return .Valid
        } else {
            return .Invalid
        }
    }
    
    private func validityOfYear() -> DateViewModel.FieldValidity {
        guard isValidInput(str: inputYear) else { return .Invalid }
        
        if inputYear.count < 4 {
            return .Incomplete
        } else if inputYear.count == 4,
                  Int(inputYear) ?? 0 >= 0 {
            return .Valid
        } else {
            print("\(inputYear) is an invalid year")
            return .Invalid
        }
    }
    
    private func userInputMatches(date: DateInRegion) -> Bool {
        let justMonth = date.toFormat("MM")
        let justDay = date.toFormat("dd")
        print(justMonth, "/", justDay)
        let monthsMatch = justMonth == inputMonth
        let daysMatch = justDay == inputDay
        print("monthsMatch =", monthsMatch)
        print("daysMatch =", daysMatch)
        
        return monthsMatch && daysMatch
    }
}

extension DateViewModel {
    static let validCharacters = "0123456789"
    
    enum FieldValidity {
        case Incomplete, Valid, Invalid
        
        var isValid: Bool {
            self == .Valid
        }
        
        var notValid: Bool {
            !isValid
        }
    }
}
