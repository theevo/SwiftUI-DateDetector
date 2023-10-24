//
//  ContentView.swift
//  SwiftUI-DateDetector
//
//  Created by Theo Vora on 10/24/23.
//

import SwiftUI

struct ContentView: View {
    @State private var str: String = ""
    
    var body: some View {
        List {
            TextField("Enter your birthdate", text: $str)
                .border(.secondary)
            Text(str)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
