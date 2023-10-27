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
    
    var body: some View {
        List {
            Text(birthdateAsString)
                .font(.largeTitle)
            HStack {
                TextField("MM", text: $monthStr)
                    .focused($focus, equals: .month)
                    .textFieldStyle(DatePartStyle())
                    .onChange(of: monthStr) { oldValue, newValue in
                        if newValue.count == 2 {
                            updateDate()
                            advanceFocus()
                        }
                    }
                TextField("DD", text: $dayStr)
                    .focused($focus, equals: .day)
                    .textFieldStyle(DatePartStyle())
                    .onChange(of: dayStr) { oldValue, newValue in
                        if newValue.count == 2 {
                            updateDate()
                            advanceFocus()
                        }
                    }
                TextField("YYYY", text: $yearStr)
                    .focused($focus, equals: .year)
                    .textFieldStyle(DatePartStyle())
                    .onChange(of: yearStr) { oldValue, newValue in
                        if let _ = newValue.toDate("yyyy") {
                            updateDate()
                        }
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
    
    private func updateDate() {
        let newValue = monthStr + dayStr + yearStr
        guard newValue.count == 8,
              let possibleDate = newValue.toDate("MMddyyyy")
        else {
            if !monthStr.isEmpty, dayStr.isEmpty, yearStr.isEmpty {
                updateOnlyMonth()
            }
            return
        }
        
        birthdateAsString = possibleDate.toFormat("MMMM dd, yyyy")
    }
    
    private func updateOnlyMonth() {
        let newValue = monthStr
        guard newValue.count == 2,
              let possibleDate = newValue.toDate("MM")
        else { return }
        
        birthdateAsString = possibleDate.toFormat("MMMM")
    }
    
    private func isValidDay() -> Bool {
        if (1...31).contains(Int(dayStr) ?? 0) {
            return true
        } else {
            print("\(dayStr) is an invalid day")
            return false
        }
    }
    
    private func isValidMonth() -> Bool {
        if (1...12).contains(Int(monthStr) ?? 0) {
            return true
        } else {
            print("\(monthStr) is an invalid month")
            return false
        }
    }
    
    private func isValidYear() -> Bool {
        if Int(yearStr) ?? 0 > 0 {
            return true
        } else {
            print("\(yearStr) is an invalid year")
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
    }
}

struct DatePartStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .border(.secondary)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.system(size: 24))
            .padding()
    }
}

#Preview {
    ContentView()
}
