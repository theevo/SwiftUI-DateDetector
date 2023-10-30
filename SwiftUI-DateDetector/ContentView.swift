//
//  ContentView.swift
//  SwiftUI-DateDetector
//
//  Created by Theo Vora on 10/24/23.
//

import SwiftUI
import SwiftDate

struct ContentView: View {
    @FocusState private var focus: FocusedField?
    @State private var birthdateAsString: String = ""
    @State private var monthStr: String = ""
    @State private var dayStr: String = ""
    @State private var yearStr: String = ""
    @State private var monthFieldStyle = DatePartStyle()
    @State private var dayFieldStyle = DatePartStyle()
    @State private var yearFieldStyle = DatePartStyle()
    
    var body: some View {
        List {
            Text(birthdateAsString)
                .font(.largeTitle)
            HStack {
                TextField("MM", text: $monthStr)
                    .focused($focus, equals: .month)
                    .textFieldStyle(monthFieldStyle)
                    .onChange(of: monthStr) {
                        previewDate()
                    }
                TextField("DD", text: $dayStr)
                    .focused($focus, equals: .day)
                    .textFieldStyle(dayFieldStyle)
                    .onChange(of: dayStr) {
                        previewDate()
                    }
                TextField("YYYY", text: $yearStr)
                    .focused($focus, equals: .year)
                    .textFieldStyle(yearFieldStyle)
                    .onChange(of: yearStr) {
                        previewDate()
                    }
            }
            HStack {
                Spacer()
                Text("Enter your birthdate")
                Spacer()
            }
        }
    }
    
    private func advanceFocus() {
        guard isValid() else { return }
        
        switch focus {
        case .month:
            focus = .day
        case .day:
            focus = .year
        case .year:
            // do nothing
            print("reached year field")
        case .none:
            print("nothing to do")
        }
    }
    
    private func previewDate() {
        updateDate()
        advanceFocus()
    }
    
    private func updateDate() {
        switch (isValidMonth(), isValidDay(), isValidYear()) {
        case (true, false, _):
            updateOnlyMonth()
        case (true, true, false):
            updateMonthAndDay()
        case (true, true, true):
            updateEntireDate()
        default:
            print("nothing to do")
        }
    }
    
    private func updateEntireDate() {
        let newValue = monthStr + dayStr + yearStr
        guard newValue.count == 8,
              let possibleDate = newValue.toDate("MMddyyyy")
        else { return }
        
        birthdateAsString = possibleDate.toFormat("MMMM dd, yyyy")
    }
    
    private func updateMonthAndDay() {
        let newValue = monthStr + dayStr
        guard let possibleDate = newValue.toDate("MMdd") else { return }
        
        birthdateAsString = possibleDate.toFormat("MMMM dd")
    }
    
    private func updateOnlyMonth() {
        let newValue = monthStr
        guard newValue.count == 2,
              let possibleDate = newValue.toDate("MM")
        else { return }
        
        birthdateAsString = possibleDate.toFormat("MMMM")
    }
    
    private func isValidDay() -> Bool {
        if dayStr.count == 2,
           (1...31).contains(Int(dayStr) ?? 0) {
            dayFieldStyle = DatePartStyle(color: .green)
            return true
        } else {
            print("\(dayStr) is an invalid day")
            dayFieldStyle = DatePartStyle(color: .red)
            return false
        }
    }
    
    private func isValidMonth() -> Bool {
        if monthStr.count == 2,
           (1...12).contains(Int(monthStr) ?? 0) {
            monthFieldStyle = DatePartStyle(color: .green)
            return true
        } else {
            print("\(monthStr) is an invalid month")
            monthFieldStyle = DatePartStyle(color: .red)
            return false
        }
    }
    
    private func isValidYear() -> Bool {
        if yearStr.count == 4,
           Int(yearStr) ?? 0 > 0 {
            yearFieldStyle = DatePartStyle(color: .green)
            return true
        } else {
            print("\(yearStr) is an invalid year")
            yearFieldStyle = DatePartStyle(color: .red)
            return false
        }
    }
    
    private func isValid() -> Bool {
        switch focus {
        case .month:
            return isValidMonth()
        case .day:
            return isValidDay()
        case .year:
            return isValidYear()
        case .none:
            return false
        }
    }
    
    enum FocusedField {
        case month, day, year
        
        // TODO: - make method isValid(_ string:) -> Bool
    }
}

struct DatePartStyle: TextFieldStyle {
    var color: Color?
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .border(color ?? .secondary)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.system(size: 24))
            .padding()
    }
}

#Preview {
    ContentView()
}
