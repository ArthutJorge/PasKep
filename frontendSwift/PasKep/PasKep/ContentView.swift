//
//  ContentView.swift
//  PasKep
//
//  Created by ION MATEUS NUNES OPREA on 05/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "cat")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, CAT!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
