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
            TextField("MMDDYYYY", text: $str)
                .border(.secondary)
                .onChange(of: str) { oldValue, newValue in
                    if let possibleDate = newValue.toDate("MMddyyyy") {
                        birthdateAsString = possibleDate.toFormat("MMMM dd, yyyy")
                    } else {
                        birthdateAsString = ""
                    }
                }
            HStack {
                TextField("MM", text: $monthStr)
                    .textFieldStyle(DatePartStyle())
                TextField("DD", text: $dayStr)
                    .textFieldStyle(DatePartStyle())
                TextField("YYYY", text: $yearStr)
                    .textFieldStyle(DatePartStyle())
            }
            HStack {
                Spacer()
                Text("Enter your birthdate")
                Spacer()
            }
        }
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
