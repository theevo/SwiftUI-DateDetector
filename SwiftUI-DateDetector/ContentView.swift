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
    @Bindable private var viewModel = DateViewModel()
    
    var body: some View {
        List {
            Text(viewModel.birthdateAsString)
                .font(.largeTitle)
            HStack {
                TextField("MM", text: $viewModel.monthStr)
                    .focused($focus, equals: .month)
                    .textFieldStyle(viewModel.monthFieldStyle)
                    .onChange(of: viewModel.monthStr) {
                        previewDate()
                    }
                TextField("DD", text: $viewModel.dayStr)
                    .focused($focus, equals: .day)
                    .textFieldStyle(viewModel.dayFieldStyle)
                    .onChange(of: viewModel.dayStr) {
                        previewDate()
                    }
                TextField("YYYY", text: $viewModel.yearStr)
                    .focused($focus, equals: .year)
                    .textFieldStyle(viewModel.yearFieldStyle)
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
        print("clearing '\(viewModel.birthdateAsString)'")
        viewModel.birthdateAsString = ""
    }
    
    private func previewDate() {
        updateColors()
        updateDate()
        advanceFocus()
    }
    
    func updateColors() {
        viewModel.monthValidityState = validityOfMonth()
        viewModel.monthFieldStyle = DatePartStyle(color: viewModel.monthValidityState.color)
        
        viewModel.dayValidityState = validityOfDay()
        viewModel.dayFieldStyle = DatePartStyle(color: viewModel.dayValidityState.color)
        
        viewModel.yearValidityState = validityOfYear()
        viewModel.yearFieldStyle = DatePartStyle(color: viewModel.yearValidityState.color)
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
            viewModel.birthdateAsString = dateToPreview
        } else {
            viewModel.birthdateAsString = "\(dateToPreview)?"
        }
    }
    
    private func updateMonthAndDay() {
        let newValue = viewModel.monthStr + viewModel.dayStr
        guard let possibleDate = newValue.toDate("MMdd") else { return }
        
        viewModel.birthdateAsString = possibleDate.toFormat("MMMM dd")
    }
    
    private func updateOnlyMonth() {
        let newValue = viewModel.monthStr
        guard newValue.count == 2,
              let possibleDate = newValue.toDate("MM")
        else { return }
        
        viewModel.birthdateAsString = possibleDate.toFormat("MMMM")
    }
    
    private func validityOfDay() -> DateViewModel.FieldValidity {
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
    
    private func validityOfMonth() -> DateViewModel.FieldValidity {
        if viewModel.monthStr.isEmpty {
            return .Empty
        } else if viewModel.monthStr.count == 2,
                  (1...12).contains(Int(viewModel.monthStr) ?? 0) {
            return .Valid
        } else {
            return .Invalid
        }
    }
    
    private func validityOfYear() -> DateViewModel.FieldValidity {
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
}

@Observable class DateViewModel {
    var monthStr: String = ""
    var dayStr: String = ""
    var yearStr: String = ""
    var birthdateAsString: String = ""
    var monthFieldStyle = DatePartStyle()
    var dayFieldStyle = DatePartStyle()
    var yearFieldStyle = DatePartStyle()
    var monthValidityState = FieldValidity.Empty
    var dayValidityState = FieldValidity.Empty
    var yearValidityState = FieldValidity.Empty
    
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
