//
//  ContentView.swift
//  SwiftUI-DateDetector
//
//  Created by Theo Vora on 10/24/23.
//

import SwiftUI

struct ContentView: View {
    @FocusState private var focus: FocusedField?
    @Bindable private var viewModel = DateViewModel()
    
    var body: some View {
        List {
            Text(viewModel.previewBirthdate)
                .font(.largeTitle)
                .animation(.spring, value: viewModel.previewBirthdate)
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
                    .frame(width: 114)
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

extension DateViewModel.FieldValidity {
    var color: Color {
        switch self {
        case .Incomplete:
            .secondary
        case .Valid:
            .green
        case .Invalid:
            .red
        }
    }
}

#Preview {
    ContentView()
}
