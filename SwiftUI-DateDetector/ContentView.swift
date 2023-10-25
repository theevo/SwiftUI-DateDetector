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
    @State private var str: String = ""
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
                            advance()
                        }
                    }
                TextField("DD", text: $dayStr)
                    .focused($focus, equals: .day)
                    .textFieldStyle(DatePartStyle())
                    .onChange(of: dayStr) { oldValue, newValue in
                        if newValue.count == 2 {
                            updateDate()
                            advance()
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
    
    private func advance() {
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
            else { return }
        
        birthdateAsString = possibleDate.toFormat("MMMM dd, yyyy")
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
