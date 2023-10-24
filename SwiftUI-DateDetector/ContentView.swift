//
//  ContentView.swift
//  SwiftUI-DateDetector
//
//  Created by Theo Vora on 10/24/23.
//

import SwiftUI
import SwiftDate

struct ContentView: View {
    @State private var dateAsString: String = ""
    @State private var str: String = ""
    
    var body: some View {
        List {
            Text(dateAsString)
                .font(.largeTitle)
            TextField("Enter your birthdate", text: $str)
                .border(.secondary)
                .onChange(of: str) { oldValue, newValue in
                    if let possibleDate = newValue.toDate() {
                        dateAsString = possibleDate.toFormat("MMMM dd, yyyy")
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
