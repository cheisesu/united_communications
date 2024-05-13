//
//  ContentView.swift
//  united_communications
//
//  Created by Dmitrii Shelonin on 13/5/24.
//

import SwiftUI
import SDK

private let api = SDKAPI()

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear(perform: {
            api.subscribe { event in
                print("EVENT", event)
            }
        })
    }
}

#Preview {
    ContentView()
}
