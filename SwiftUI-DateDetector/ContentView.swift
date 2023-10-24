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
        VStack {
            Text("This is what you entered: \(str)")
            TextField("Enter your birthdate", text: $str)
                .border(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
