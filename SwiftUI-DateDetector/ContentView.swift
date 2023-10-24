//
//  ContentView.swift
//  SwiftUI-DateDetector
//
//  Created by Theo Vora on 10/24/23.
//

import SwiftUI

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
                    dateAsString = "December 17, 1983"
                }
            Text(str)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
