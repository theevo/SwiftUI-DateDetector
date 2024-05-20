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
        VStack {
            DateEntryView(viewModel: viewModel)
            if viewModel.isValid {
                Button("Continue") {
                    print("Continue button pressed!")
                }
                .buttonStyle(BlueButton())
            }
        }
    }
}

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 1.0, opacity: 0.72))
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

#Preview {
    ContentView(viewModel: DateViewModel(month: "01", day: "03", year: "2012"))
}

#Preview {
    ContentView(viewModel: DateViewModel())
}
