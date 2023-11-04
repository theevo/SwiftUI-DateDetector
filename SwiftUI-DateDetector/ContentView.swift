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
            Text(viewModel.previewBirthdate)
                .font(.largeTitle)
            HStack {
                TextField("MM", text: $viewModel.inputMonth)
                    .focused($focus, equals: .month)
                    .textFieldStyle(viewModel.monthFieldStyle)
                    .onChange(of: viewModel.inputMonth) {
                        render()
                    }
                TextField("DD", text: $viewModel.inputDay)
                    .focused($focus, equals: .day)
                    .textFieldStyle(viewModel.dayFieldStyle)
                    .onChange(of: viewModel.inputDay) {
                        render()
                    }
                TextField("YYYY", text: $viewModel.inputYear)
                    .focused($focus, equals: .year)
                    .textFieldStyle(viewModel.yearFieldStyle)
                    .onChange(of: viewModel.inputYear) {
                        render()
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
    
    private func render() {
        viewModel.updateColors()
        viewModel.previewDate()
        advanceFocus()
    }
    
    private func isValid() -> Bool {
        switch focus {
        case .month:
            return viewModel.validityOfMonth() == .Valid
        case .day:
            return viewModel.validityOfDay() == .Valid
        case .year:
            return viewModel.validityOfYear() == .Valid
        case .none:
            return false
        }
    }
    
    enum FocusedField {
        case month, day, year
    }
}

@Observable class DateViewModel {
    var inputMonth: String = ""
    var inputDay: String = ""
    var inputYear: String = ""
    var monthFieldStyle = DatePartStyle()
    var dayFieldStyle = DatePartStyle()
    var yearFieldStyle = DatePartStyle()
    var monthValidityState = FieldValidity.Empty
    var dayValidityState = FieldValidity.Empty
    var yearValidityState = FieldValidity.Empty
    private(set) var previewBirthdate: String = ""
    
    
    // MARK: - Public Methods
    
    func clearPreview() {
        print("clearing '\(previewBirthdate)'")
        previewBirthdate = ""
    }
    
    func previewDate() {
        switch (validityOfMonth(), validityOfDay(), validityOfYear()) {
        case (.Valid, .Empty, _),
            (.Valid, .Invalid, _):
            previewMonthOnly()
        case (.Valid, .Valid, .Empty),
            (.Valid, .Valid, .Invalid):
            previewMonthAndDay()
        case (.Valid, .Valid, .Valid):
            previewEntireDate()
        default:
            clearPreview()
        }
    }
    
    func updateColors() {
        monthValidityState = validityOfMonth()
        monthFieldStyle = DatePartStyle(color: monthValidityState.color)
        
        dayValidityState = validityOfDay()
        dayFieldStyle = DatePartStyle(color: dayValidityState.color)
        
        yearValidityState = validityOfYear()
        yearFieldStyle = DatePartStyle(color: yearValidityState.color)
    }
    
    func validityOfDay() -> DateViewModel.FieldValidity {
        if inputDay.isEmpty {
            return .Empty
        } else if inputDay.count == 2,
                  (1...31).contains(Int(inputDay) ?? 0) {
            return .Valid
        } else {
            print("\(inputDay) is an invalid day")
            return .Invalid
        }
    }
    
    func validityOfMonth() -> DateViewModel.FieldValidity {
        if inputMonth.isEmpty {
            return .Empty
        } else if inputMonth.count == 2,
                  (1...12).contains(Int(inputMonth) ?? 0) {
            return .Valid
        } else {
            return .Invalid
        }
    }
    
    func validityOfYear() -> DateViewModel.FieldValidity {
        if inputYear.isEmpty {
            return .Empty
        } else if inputYear.count == 4,
                  Int(inputYear) ?? 0 > 0 {
            return .Valid
        } else {
            print("\(inputYear) is an invalid year")
            return .Invalid
        }
    }
    
    // MARK: - Private
    
    private func previewEntireDate() {
        let newValue = inputMonth + inputDay + inputYear
        guard newValue.count == 8,
              let possibleDate = newValue.toDate("MMddyyyy")
        else { return }
        
        let justMonth = possibleDate.toFormat("MM")
        let justDay = possibleDate.toFormat("dd")
        print(justMonth, "/", justDay)
        let monthsMatch = justMonth == inputMonth
        let daysMatch = justDay == inputDay
        print("monthsMatch =", monthsMatch)
        print("daysMatch =", daysMatch)
        
        let dateToPreview = possibleDate.toFormat("MMMM dd, yyyy")
        
        if monthsMatch, daysMatch {
            previewBirthdate = dateToPreview
        } else {
            previewBirthdate = "\(dateToPreview)?"
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
}

extension DateViewModel {
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
