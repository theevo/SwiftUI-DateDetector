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
                Spacer()
                Text("Enter your birthdate")
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
