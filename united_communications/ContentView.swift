//
//  ContentView.swift
//  united_communications
//
//  Created by Dmitrii Shelonin on 13/5/24.
//

import SwiftUI
import SDK

private let api = try! SDKAPI()

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
            api.subscribe(handler: handler)
        })
    }

    @Sendable
    func handler(_ event: NSDate) {
        print("EVENT", event)
    }
}

#Preview {
    ContentView()
}
