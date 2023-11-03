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
    @StateObject private var viewModel = DateViewModel()
    
    @State private var birthdateAsString: String = ""
    
    @State private var monthFieldStyle = DatePartStyle()
    @State private var dayFieldStyle = DatePartStyle()
    @State private var yearFieldStyle = DatePartStyle()
    @State private var monthValidityState = FieldValidity.Empty
    @State private var dayValidityState = FieldValidity.Empty
    @State private var yearValidityState = FieldValidity.Empty
    
    var body: some View {
        List {
            Text(birthdateAsString)
                .font(.largeTitle)
            HStack {
                TextField("MM", text: $viewModel.monthStr)
                    .focused($focus, equals: .month)
                    .textFieldStyle(monthFieldStyle)
                    .onChange(of: viewModel.monthStr) {
                        previewDate()
                    }
                TextField("DD", text: $viewModel.dayStr)
                    .focused($focus, equals: .day)
                    .textFieldStyle(dayFieldStyle)
                    .onChange(of: viewModel.dayStr) {
                        previewDate()
                    }
                TextField("YYYY", text: $viewModel.yearStr)
                    .focused($focus, equals: .year)
                    .textFieldStyle(yearFieldStyle)
                    .onChange(of: viewModel.yearStr) {
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
    
    private func clear() {
        print("clearing '\(birthdateAsString)'")
        birthdateAsString = ""
    }
    
    private func previewDate() {
        updateColors()
        updateDate()
        advanceFocus()
    }
    
    func updateColors() {
        monthValidityState = validityOfMonth()
        monthFieldStyle = DatePartStyle(color: monthValidityState.color)
        
        dayValidityState = validityOfDay()
        dayFieldStyle = DatePartStyle(color: dayValidityState.color)
        
        yearValidityState = validityOfYear()
        yearFieldStyle = DatePartStyle(color: yearValidityState.color)
    }
    
    private func updateDate() {
        switch (validityOfMonth(), validityOfDay(), validityOfYear()) {
        case (.Valid, .Empty, _), 
             (.Valid, .Invalid, _):
            updateOnlyMonth()
        case (.Valid, .Valid, .Empty),
             (.Valid, .Valid, .Invalid):
            updateMonthAndDay()
        case (.Valid, .Valid, .Valid):
            updateEntireDate()
        default:
            clear()
        }
    }
    
    private func updateEntireDate() {
        let newValue = viewModel.monthStr + viewModel.dayStr + viewModel.yearStr
        guard newValue.count == 8,
              let possibleDate = newValue.toDate("MMddyyyy")
        else { return }
        
        let justMonth = possibleDate.toFormat("MM")
        let justDay = possibleDate.toFormat("dd")
        print(justMonth, "/", justDay)
        let monthsMatch = justMonth == viewModel.monthStr
        let daysMatch = justDay == viewModel.dayStr
        print("monthsMatch =", monthsMatch)
        print("daysMatch =", daysMatch)
        
        let dateToPreview = possibleDate.toFormat("MMMM dd, yyyy")
        
        if monthsMatch, daysMatch {
            birthdateAsString = dateToPreview
        } else {
            birthdateAsString = "\(dateToPreview)?"
        }
    }
    
    private func updateMonthAndDay() {
        let newValue = viewModel.monthStr + viewModel.dayStr
        guard let possibleDate = newValue.toDate("MMdd") else { return }
        
        birthdateAsString = possibleDate.toFormat("MMMM dd")
    }
    
    private func updateOnlyMonth() {
        let newValue = viewModel.monthStr
        guard newValue.count == 2,
              let possibleDate = newValue.toDate("MM")
        else { return }
        
        birthdateAsString = possibleDate.toFormat("MMMM")
    }
    
    private func validityOfDay() -> FieldValidity {
        if viewModel.dayStr.isEmpty {
            return .Empty
        } else if viewModel.dayStr.count == 2,
                  (1...31).contains(Int(viewModel.dayStr) ?? 0) {
            return .Valid
        } else {
            print("\(viewModel.dayStr) is an invalid day")
            return .Invalid
        }
    }
    
    private func validityOfMonth() -> FieldValidity {
        if viewModel.monthStr.isEmpty {
            return .Empty
        } else if viewModel.monthStr.count == 2,
                  (1...12).contains(Int(viewModel.monthStr) ?? 0) {
            return .Valid
        } else {
            return .Invalid
        }
    }
    
    private func validityOfYear() -> FieldValidity {
        if viewModel.yearStr.isEmpty {
            return .Empty
        } else if viewModel.yearStr.count == 4,
                  Int(viewModel.yearStr) ?? 0 > 0 {
            return .Valid
        } else {
            print("\(viewModel.yearStr) is an invalid year")
            return .Invalid
        }
    }
    
    private func isValid() -> Bool {
        switch focus {
        case .month:
            return validityOfMonth() == .Valid
        case .day:
            return validityOfDay() == .Valid
        case .year:
            return validityOfYear() == .Valid
        case .none:
            return false
        }
    }
    
    enum FocusedField {
        case month, day, year
        
        // TODO: - make method isValid(_ string:) -> Bool
    }
    
    enum FieldValidity {
        case Empty, Valid, Invalid
        
        var color: Color {
            switch self {
            case .Empty:
                .secondary
            case .Valid:
                .green
            case .Invalid:
                .red
            }
        }
    }
}

extension ContentView {
    @MainActor class DateViewModel: ObservableObject {
        @Published var monthStr: String = ""
        @Published var dayStr: String = ""
        @Published var yearStr: String = ""
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
