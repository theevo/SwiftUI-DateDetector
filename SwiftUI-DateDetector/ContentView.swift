//
//  ContentView.swift
//  SwiftUI-DateDetector
//
//  Created by Theo Vora on 10/24/23.
//

import SwiftUI
import SwiftDate

struct ContentView: View {
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
                    .textFieldStyle(DatePartStyle())
                    .onChange(of: monthStr) { oldValue, newValue in
                        if let _ = newValue.toDate("MM") {
                            updateDate()
                        }
                    }
                TextField("DD", text: $dayStr)
                    .textFieldStyle(DatePartStyle())
                    .onChange(of: dayStr) { oldValue, newValue in
                        if let _ = newValue.toDate("dd") {
                            updateDate()
                        }
                    }
                TextField("YYYY", text: $yearStr)
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
    
    private func updateDate() {
        let newValue = monthStr + dayStr + yearStr
        guard newValue.count == 8,
              let possibleDate = newValue.toDate("MMddyyyy")
            else { return }
        
        birthdateAsString = possibleDate.toFormat("MMMM dd, yyyy")
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
