//
//  ContentView.swift
//  SwiftUI-DateDetector
//
//  Created by Theo Vora on 10/24/23.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = DateViewModel()
    
    var body: some View {
        DateEntryView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}
