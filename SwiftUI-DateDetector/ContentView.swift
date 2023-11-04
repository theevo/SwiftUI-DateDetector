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
        guard viewModel.canAdvance(from: focus) else { return }
        
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
    private(set) var previewBirthdate: String = ""
    
    
    // MARK: - Public Methods
    
    public func canAdvance(from focus: ContentView.FocusedField?) -> Bool {
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
        monthFieldStyle = DatePartStyle(color: monthValidity.color)
        
        dayFieldStyle = DatePartStyle(color: dayValidity.color)
        
        yearFieldStyle = DatePartStyle(color: yearValidity.color)
    }
    
    // MARK: - Private
    
    private func previewEntireDate() {
        let newValue = inputMonth + inputDay + inputYear
        guard newValue.count == 8,
              let possibleDate = newValue.toDate("MMddyyyy")
        else { return }
        
        let dateToPreview = possibleDate.toFormat("MMMM dd, yyyy")
        
        if userInputMatches(date: possibleDate) {
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
    
    private func validityOfDay() -> DateViewModel.FieldValidity {
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
    
    private func validityOfMonth() -> DateViewModel.FieldValidity {
        if inputMonth.isEmpty {
            return .Empty
        } else if inputMonth.count == 2,
                  (1...12).contains(Int(inputMonth) ?? 0) {
            return .Valid
        } else {
            return .Invalid
        }
    }
    
    private func validityOfYear() -> DateViewModel.FieldValidity {
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
        
        var isValid: Bool {
            self == .Valid
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
